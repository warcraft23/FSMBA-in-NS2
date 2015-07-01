/*
 * fsmba_pkt.h
 *
 *  Created on: 2015年6月30日
 *      Author: edward
 */

#ifndef FSMBA_FSMBA_PKT_H_
#define FSMBA_FSMBA_PKT_H_

#include <packet.h>

/*	===============================================
 * Packet Format
 ================================================*/
#define FSMBATYPE_HELLO 0x01
#define FSMBATYPE_BROAD 0x02

/*
 * Fast and Secure Multi-hop Broadcast Algorithm Header Macros
 */
#define HDR_FSMBA_PKT(p) ((struct hdr_fsmba_pkt *)hdr_fsmba_pkt::access(p))
#define HDR_FSMBA_HELLO_PKT(p) ((struct hdr_fsmba_hello_pkt *)hdr_fsmba_hello_pkt::access(p))
#define HDR_FSMBA_BROAD_PKT(p) ((struct hdr_fsmba_broad_pkt *)hdr_fsmba_broad_pkt::access(p))

struct pos{
	int x;
	int y;
};

//header for FSMBA packet
struct hdr_fsmba_pkt{
	//packet type
	int pkt_type_;

	inline int& pkt_type(){return pkt_type_;}

	//offset
	static int offset_;

	inline int& offset(){return offset_;}

	inline static hdr_fsmba_pkt* access(Packet *p){
		return (hdr_fsmba_pkt *)p->access(offset_);
	}
};

//header for FSMBA hellomsg packet
struct hdr_fsmba_hello_pkt{
	int pkt_type_;
	nsaddr_t pkt_src_;
	struct pos pos_;
	int declared_max_range_;

	inline int& pkt_type(){return pkt_type_;}
	inline int& declared_max_range(){return declared_max_range_;}
	inline nsaddr_t& pkt_src(){return pkt_src_;}
	inline int& xPos(){
		return pos_.x;
	}
	inline int& yPos(){
		return pos_.y;
	}
};

//header for FSMBA broadcast packet
struct hdr_fsmba_broadcast_pkt{
	int pkt_type_;
	nsaddr_t pkt_orgin_;//the vehicle which generates the pkt
	nsaddr_t pkt_src_;//the vehicle which transmits the pkt
	struct pos pos_;//the position of the vehicle which transmits the pkt
	int declared_max_range_;//how far that transmission is expected to go backward before the signal becomes too weak to be intelligible

	inline int& pkt_type(){return pkt_type_;}
	inline nsaddr_t& pkt_origin(){return pkt_orgin_;}
	inline nsaddr_t& pkt_src(){return pkt_src_;}
	inline int& xPos(){
		return pos_.x;
	}
	inline int& yPos(){
		return pos_.y;
	}
	inline int& declared_max_range(){return declared_max_range_;}
};

#endif /* FSMBA_FSMBA_PKT_H_ */
