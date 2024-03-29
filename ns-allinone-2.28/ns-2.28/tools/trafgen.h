/* -*-	Mode:C++; c-basic-offset:8; tab-width:8; indent-tabs-mode:t -*- */
/*
 * Copyright (c) Xerox Corporation 1997. All rights reserved.
 *  
 * License is granted to copy, to use, and to make and to use derivative
 * works for research and evaluation purposes, provided that Xerox is
 * acknowledged in all documentation pertaining to any such copy or derivative
 * work. Xerox grants no other licenses expressed or implied. The Xerox trade
 * name should not be used in any advertising without its written permission.
 *  
 * XEROX CORPORATION MAKES NO REPRESENTATIONS CONCERNING EITHER THE
 * MERCHANTABILITY OF THIS SOFTWARE OR THE SUITABILITY OF THIS SOFTWARE
 * FOR ANY PARTICULAR PURPOSE.  The software is provided "as is" without
 * express or implied warranty of any kind.
 *
 * These notices must be retained in any copies of any part of this software.
 *
 * Changes by the Daedalus group, http://daedalus.cs.berkeley.edu
 *	Add Application interface
 *
 * @(#) $Header: /nfs/jade/vint/CVSROOT/ns-2/tools/trafgen.h,v 1.6 1998/06/27 01:03:28 gnguyen Exp $ (Xerox)
 */

#ifndef ns_trafgen_h
#define ns_trafgen_h

#include "app.h"
#include "timer-handler.h"

class TrafficGenerator;

class TrafficTimer : public TimerHandler {
public:
	TrafficTimer(TrafficGenerator* tg) : tgen_(tg) {}
protected:
	void expire(Event*);
	TrafficGenerator* tgen_;
};


/* abstract class for traffic generation modules.  derived classes
 * must define  the next_interval() function.  the traffic generation 
 * module schedules an event for a UDP_Agent when it is time to 
 * generate a new packet.  it passes the packet size with the event 
 * (to accommodate traffic generation modules that may not use fixed 
 * size packets).
 */

/* abstract class for traffic generation modules.  derived classes
 * must define the next_interva() function that is invoked by
 * UDP_Agent.  This function returns the time to the next packet
 * is generated and sets the size of the packet (which is passed
 * by reference).  The init() method is called from the start()
 * method of the UDP_Agent.  It can do any one-time initialization
 * needed by the traffic generation process.
 */

class TrafficGenerator : public Application {
public:
	TrafficGenerator();
	virtual double next_interval(int &) = 0;
	virtual void init() {}
	virtual double interval() { return 0; }
	virtual int on() { return 0; }
	virtual void timeout();

	virtual void recv() {}
	virtual void resume() {}

protected:
	virtual void start();
	virtual void stop();

	double nextPkttime_;
	int size_;
	int running_;
	TrafficTimer timer_;
};

#endif
