/*
 * fsmba.h
 *
 *  Created on: 2015年6月30日
 *      Author: edward
 */

#ifndef FSMBA_FSMBA_H_
#define FSMBA_FSMBA_H_

#include "fsmba_pkt.h"

#include  <agent.h>
#include  <packet.h>
#include  <trace.h>
#include  <timer-handler.h>
#include  <random.h>
#include  <classifier-port.h>
#include <mobilenode.h>

/*==========================
 * Parameter Setting
 ===========================*/
#define CWMax 100
#define CWMin 20
#define TURN_SIZE 1

#define CURRENT_TIME           Scheduler::instance().clock()

#define VEHICLE_SPEED 10.0

class Fsmba;//forward declaration

class Fsmba :public Agent{

	//private members

	//the network address of the node
	nsaddr_t myAddress_;

	//the physical position of the node
	int xPos_;
	int yPos_;

};



#endif /* FSMBA_FSMBA_H_ */
