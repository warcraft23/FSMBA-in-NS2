#include "agent.h"
#include "address.h"
#include "ip.h"
#include "bbcast-packet.h"
#include "timer-handler.h"
#include "packet.h"
#include "app.h"
#include "BroadcastbaseAgent.h"
#include "BroadcastbaseApp.h"
#include <iostream> 

FILE * rangeFile=fopen ("range.tr","at");
FILE * traceFile=fopen ("trace.tr","at");

// bind C++ to TCL
static class BroadcastbaseClass : public TclClass {
public:
	BroadcastbaseClass() : TclClass("Agent/Broadcastbase"){}
	TclObject* create(int, const char*const*) {
		return (new BroadcastbaseAgent());
	}
} class_broadbastbase;



// Constructor
BroadcastbaseAgent::BroadcastbaseAgent() : Agent(PT_BROADCASTBASE)
{}  

// OTcl command interpreter
int BroadcastbaseAgent::command(int argc, const char*const* argv)
{
	return (Agent::command(argc, argv));
}

//procedure to send broadcast msg 从app那获得了数据包然后通过底层函数广播
void BroadcastbaseAgent::sendbroadcastmsg(int realsize,BBCastData *data, long int id)
{	
	/* create packet and set header field */
	long int pktid;
	int size=100; //min length for pkt
	if (realsize >size) size=realsize;
	Packet *pkt = allocpkt(size);
	struct hdr_cmn *ch = HDR_CMN(pkt);
	struct hdr_ip *ih = HDR_IP(pkt);
	ch->ptype() = PT_BROADCASTBASE;
	ch->next_hop_ = IP_BROADCAST;
	ih->saddr() = Agent::addr();
	ih->daddr() = IP_BROADCAST;
	ih->sport() = 250;
	ih->dport() = 250;
	ih->ttl_ = 1;

	//return the point to the BBCastData in pkt
	char *p = (char*)pkt->accessdata();
	if (id < 0) { //new broadcast pkt
		pktid=ch->uid();
				
	}
	else { /* forwarding a broadcast pkt, same id and flow id are setted */
		pktid=id;
		
	}
	((BBCastData *)data)->set_id(pktid);
	ih->flowid()=pktid;
	
	//print: send time src_addr real_pkt_id flow_id
	fprintf (traceFile,"s %.9f %d %d %d\n",Scheduler::instance().clock(),Agent::addr(),ch->uid(),pktid);
	fflush(traceFile);
	
	
	data->pack(p);
	
	Agent::send(pkt, 0);
}



/* receive a broadcast pkt and pass it to process data procedure
 * 获得底层的数据包然后交给上层的app处理
 * */
void BroadcastbaseAgent::recv(Packet* p, Handler* h)
{
	
	hdr_ip* ih = hdr_ip::access(p);

	((BroadcastbaseApp*)app_)->process_data_BroadcastMsg((char*)p->accessdata(), ih);
	
	Packet::free(p);
}


