#
# Copyright (c) 1995 The Regents of the University of California.
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
# 3. All advertising materials mentioning features or use of this software
#    must display the following acknowledgement:
#	This product includes software developed by the Computer Systems
#	Engineering Group at Lawrence Berkeley Laboratory.
# 4. Neither the name of the University nor of the Laboratory may be used
#    to endorse or promote products derived from this software without
#    specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ``AS IS'' AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED.  IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
# OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
# HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
# LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
# OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
# SUCH DAMAGE.
#
# @(#) $Header: /nfs/jade/vint/CVSROOT/ns-2/tcl/test/test-suite-tcpVariants.tcl,v 1.27 2004/10/18 19:42:18 sfloyd Exp $
#
# To view a list of available tests to run with this script:
# ns test-suite-tcpVariants.tcl
#

source misc_simple.tcl
# FOR UPDATING GLOBAL DEFAULTS:
Agent/TCP set minrto_ 1
# default changed on 10/14/2004.
Agent/TCP/Newreno set newreno_changes1_ 0
# The default is being changed to 1 on 5/5/03, to reflect RFC 2582.
Agent/TCP/Newreno set partial_window_deflation_ 0  
# The default is being changed to 1 on 5/5/03, to reflect RFC 2582.
Agent/TCP set singledup_ 0
# The default has been changed to 1

Trace set show_tcphdr_ 1

set wrap 90
set wrap1 [expr $wrap * 512 + 40]

Class Topology

Topology instproc node? num {
    $self instvar node_
    return $node_($num)
}

#
# Links1 uses 8Mb, 5ms feeders, and a 800Kb 10ms bottleneck.
# Queue-limit on bottleneck is 2 packets.
#
Class Topology/net4 -superclass Topology
Topology/net4 instproc init ns {
    $self instvar node_
    set node_(s1) [$ns node]
    set node_(s2) [$ns node]
    set node_(r1) [$ns node]
    set node_(k1) [$ns node]

    $self next
    $ns duplex-link $node_(s1) $node_(r1) 8Mb 0ms DropTail
    $ns duplex-link $node_(s2) $node_(r1) 8Mb 0ms DropTail
    $ns duplex-link $node_(r1) $node_(k1) 800Kb 100ms DropTail
    $ns queue-limit $node_(r1) $node_(k1) 8
    $ns queue-limit $node_(k1) $node_(r1) 8

    $self instvar lossylink_
    set lossylink_ [$ns link $node_(r1) $node_(k1)]
    set em [new ErrorModule Fid]
    set errmodel [new ErrorModel/Periodic]
    $errmodel unit pkt
    $lossylink_ errormodule $em
}


TestSuite instproc finish file {
	global quiet wrap wrap1 PERL
        set space 512
        if [string match {*full*} $file] {
                exec $PERL ../../bin/getrc -s 2 -d 3 all.tr | \
                   $PERL ../../bin/raw2xg -c -n $space -s 0.01 -m $wrap1 -t $file > temp.rands
                exec $PERL ../../bin/getrc -s 3 -d 2 all.tr | \
                   $PERL ../../bin/raw2xg -a -c -f -p -y -n $space -s 0.01 -m $wrap1 -t $file >> temp.rands
        } else {
                exec $PERL ../../bin/getrc -s 2 -d 3 all.tr | \
                  $PERL ../../bin/raw2xg -s 0.01 -m $wrap -t $file > temp.rands
                exec $PERL ../../bin/getrc -s 3 -d 2 all.tr | \
                  $PERL ../../bin/raw2xg -a -c -p -y -s 0.01 -m $wrap -t $file \
                  >> temp.rands
        }  
        #exec $PERL ../../bin/set_flow_id -s all.tr | \
        #  $PERL ../../bin/getrc -s 2 -d 3 | \
        #  $PERL ../../bin/raw2xg -s 0.01 -m $wrap -t $file > temp.rands
	if {$quiet == "false"} {
		exec xgraph -bb -tk -nl -m -x time -y packets temp.rands &
	}
        ## now use default graphing tool to make a data file
	## if so desired
        exit 0
}

TestSuite instproc printtimers { tcp time} {
	global quiet
	if {$quiet == "false"} {
        	puts "time: $time sRTT(in ticks): [$tcp set srtt_]/8 RTTvar(in ticks): [$tcp set rttvar_]/4 backoff: [$tcp set backoff_]"
	}
}

TestSuite instproc printtimersAll { tcp time interval } {
        $self instvar dump_inst_ ns_
        if ![info exists dump_inst_($tcp)] {
                set dump_inst_($tcp) 1
                $ns_ at $time "$self printtimersAll $tcp $time $interval"
                return
        }
	set newTime [expr [$ns_ now] + $interval]
	$ns_ at $time "$self printtimers $tcp $time"
        $ns_ at $newTime "$self printtimersAll $tcp $newTime $interval"
}


TestSuite instproc emod {} {
        $self instvar topo_
        $topo_ instvar lossylink_
        set errmodule [$lossylink_ errormodule]
        return $errmodule
} 

TestSuite instproc drop_pkts pkts {
    $self instvar ns_
    set emod [$self emod]
    set errmodel1 [new ErrorModel/List]
    $errmodel1 droplist $pkts
    $emod insert $errmodel1
    $emod bind $errmodel1 1
}
 
TestSuite instproc setup {tcptype list} {
	global wrap wrap1
        $self instvar ns_ node_ testName_
	$self setTopo

        ###Agent/TCP set bugFix_ false
	set fid 1
        # Set up TCP connection
    	if {$tcptype == "Tahoe"} {
      		set tcp1 [$ns_ create-connection TCP $node_(s1) \
          	TCPSink $node_(k1) $fid]
    	} elseif {$tcptype == "Sack1"} {
      		set tcp1 [$ns_ create-connection TCP/Sack1 $node_(s1) \
          	TCPSink/Sack1  $node_(k1) $fid]
    	} elseif {$tcptype == "Fack"} {
      		set tcp1 [$ns_ create-connection TCP/Fack $node_(s1) \
          	TCPSink/Sack1  $node_(k1) $fid]
    	} elseif {$tcptype == "SackRH"} {
      		set tcp1 [$ns_ create-connection TCP/SackRH $node_(s1) \
          	TCPSink/Sack1 $node_(k1) $fid]
    	} elseif {$tcptype == "FullTcp"} {
		set wrap $wrap1
	        set tcp1 [new Agent/TCP/FullTcp]
	        set sink [new Agent/TCP/FullTcp]
	        $ns_ attach-agent $node_(s1) $tcp1
	        $ns_ attach-agent $node_(k1) $sink
	        $tcp1 set fid_ $fid
	        $sink set fid_ $fid
	        $ns_ connect $tcp1 $sink
	        # set up TCP-level connections
	        $sink listen ; # will figure out who its peer is
    	} elseif {$tcptype == "FullTcpTahoe"} {
		set wrap $wrap1
	        set tcp1 [new Agent/TCP/FullTcp/Tahoe]
	        set sink [new Agent/TCP/FullTcp/Tahoe]
	        $ns_ attach-agent $node_(s1) $tcp1
	        $ns_ attach-agent $node_(k1) $sink
	        $tcp1 set fid_ $fid
	        $sink set fid_ $fid
	        $ns_ connect $tcp1 $sink
	        # set up TCP-level connections
	        $sink listen ; # will figure out who its peer is
    	} elseif {$tcptype == "FullTcpNewreno"} {
		set wrap $wrap1
	        set tcp1 [new Agent/TCP/FullTcp/Newreno]
	        set sink [new Agent/TCP/FullTcp/Newreno]
	        $ns_ attach-agent $node_(s1) $tcp1
	        $ns_ attach-agent $node_(k1) $sink
	        $tcp1 set fid_ $fid
	        $sink set fid_ $fid
	        $ns_ connect $tcp1 $sink
	        # set up TCP-level connections
	        $sink listen ; # will figure out who its peer is
    	} elseif {$tcptype == "FullTcpSack1"} {
		set wrap $wrap1
	        set tcp1 [new Agent/TCP/FullTcp/Sack]
	        set sink [new Agent/TCP/FullTcp/Sack]
	        $ns_ attach-agent $node_(s1) $tcp1
	        $ns_ attach-agent $node_(k1) $sink
	        $tcp1 set fid_ $fid
	        $sink set fid_ $fid
	        $ns_ connect $tcp1 $sink
	        # set up TCP-level connections
	        $sink listen ; # will figure out who its peer is
    	} else {
      		set tcp1 [$ns_ create-connection TCP/$tcptype $node_(s1) \
          	TCPSink $node_(k1) $fid]
    	}
        $tcp1 set window_ 28
        set ftp1 [$tcp1 attach-app FTP]
        $ns_ at 1.0 "$ftp1 start"

        $self tcpDump $tcp1 5.0
        $self drop_pkts $list

        #$self traceQueues $node_(r1) [$self openTrace 6.0 $testName_]
	$ns_ at 6.0 "$self cleanupAll $testName_"
        $ns_ run
}

# Definition of test-suite tests

###################################################
## One drop
###################################################

Class Test/onedrop_tahoe -superclass TestSuite
Test/onedrop_tahoe instproc init {} {
	$self instvar net_ test_
	set net_	net4
	set test_	onedrop_tahoe
	$self next pktTraceFile
}
Test/onedrop_tahoe instproc run {} {
        $self setup Tahoe {14}
}

Class Test/onedrop_SA_tahoe -superclass TestSuite
Test/onedrop_SA_tahoe instproc init {} {
	$self instvar net_ test_
	set net_	net4
	set test_	onedrop_SA_tahoe
	Agent/TCP set singledup_ 1
	Test/onedrop_SA_tahoe instproc run {} [Test/onedrop_tahoe info instbody run ]
	$self next pktTraceFile
}

Class Test/onedrop_tahoe_full -superclass TestSuite
Test/onedrop_tahoe_full instproc init {} {
	$self instvar net_ test_
	set net_	net4
	set test_	onedrop_tahoe_full
	$self next pktTraceFile
}
Test/onedrop_tahoe_full instproc run {} {
        $self setup FullTcpTahoe {16}
}

Class Test/onedrop_reno -superclass TestSuite
Test/onedrop_reno instproc init {} {
	$self instvar net_ test_
	set net_	net4
	set test_	onedrop_reno
	$self next pktTraceFile
}
Test/onedrop_reno instproc run {} {
        $self setup Reno {14}
}

Class Test/onedrop_SA_reno -superclass TestSuite
Test/onedrop_SA_reno instproc init {} {
	$self instvar net_ test_
	set net_	net4
	set test_	onedrop_SA_reno
	Agent/TCP set singledup_ 1
	Test/onedrop_SA_reno instproc run {} [Test/onedrop_reno info instbody run ]
	$self next pktTraceFile
}

Class Test/onedrop_reno_full -superclass TestSuite
Test/onedrop_reno_full instproc init {} {

	$self instvar net_ test_
	set net_	net4
	set test_	onedrop_reno_full
	$self next pktTraceFile
}
Test/onedrop_reno_full instproc run {} {
        $self setup FullTcp {16}
}

Class Test/onedrop_newreno -superclass TestSuite
Test/onedrop_newreno instproc init {} {
	$self instvar net_ test_
	set net_	net4
	set test_	onedrop_newreno
	$self next pktTraceFile
}
Test/onedrop_newreno instproc run {} {
        $self setup Newreno {14}
}

Class Test/onedrop_SA_newreno -superclass TestSuite
Test/onedrop_SA_newreno instproc init {} {
	$self instvar net_ test_
	set net_	net4
	set test_	onedrop_SA_newreno
	Agent/TCP set singledup_ 1
	Test/onedrop_SA_newreno instproc run {} [Test/onedrop_newreno info instbody run ]
	$self next pktTraceFile
}

Class Test/onedrop_newreno_full -superclass TestSuite
Test/onedrop_newreno_full instproc init {} {
	$self instvar net_ test_
	set net_	net4
	set test_	onedrop_newreno_full
	$self next pktTraceFile
}
Test/onedrop_newreno_full instproc run {} {
        $self setup FullTcpNewreno {16}
}

Class Test/onedrop_sack -superclass TestSuite
Test/onedrop_sack instproc init {} {
	$self instvar net_ test_
	set net_	net4
	set test_	onedrop_sack
	$self next pktTraceFile
}
Test/onedrop_sack instproc run {} {
        $self setup Sack1 {14}
}

Class Test/onedrop_SA_sack -superclass TestSuite
Test/onedrop_SA_sack instproc init {} {
	$self instvar net_ test_
	set net_	net4
	set test_	onedrop_SA_sack
	Agent/TCP set singledup_ 1
	Test/onedrop_SA_sack instproc run {} [Test/onedrop_sack info instbody run ]
	$self next pktTraceFile
}

Class Test/onedrop_sack_full -superclass TestSuite
Test/onedrop_sack_full instproc init {} {
	$self instvar net_ test_
	set net_	net4
	set test_	onedrop_sack_full
	$self next pktTraceFile
}
Test/onedrop_sack_full instproc run {} {
        $self setup FullTcpSack1 {16}
}

Class Test/onedrop_fack -superclass TestSuite
Test/onedrop_fack instproc init {} {
	$self instvar net_ test_
	set net_	net4
	set test_	onedrop_fack
	$self next pktTraceFile
}
Test/onedrop_fack instproc run {} {
        $self setup Fack {14}
}

Class Test/onedrop_sackRH -superclass TestSuite
Test/onedrop_sackRH instproc init {} {
	$self instvar net_ test_
	set net_	net4
	set test_	onedrop_sackRH
	$self next pktTraceFile
}
Test/onedrop_sackRH instproc run {} {
        $self setup SackRH {14}
}

###################################################
## Two drops
###################################################

Class Test/twodrops_tahoe -superclass TestSuite
Test/twodrops_tahoe instproc init {} {
	$self instvar net_ test_
	set net_	net4
	set test_	twodrops_tahoe
	$self next pktTraceFile
}
Test/twodrops_tahoe instproc run {} {
        $self setup Tahoe {14 28}
}

Class Test/twodrops_SA_tahoe -superclass TestSuite
Test/twodrops_SA_tahoe instproc init {} {
	$self instvar net_ test_
	set net_	net4
	set test_	twodrops_SA_tahoe
	Agent/TCP set singledup_ 1
	Test/twodrops_SA_tahoe instproc run {} [Test/twodrops_tahoe info instbody run ]
	$self next pktTraceFile
}

Class Test/twodrops_tahoe_full -superclass TestSuite
Test/twodrops_tahoe_full instproc init {} {
	$self instvar net_ test_
	set net_	net4
	set test_	twodrops_tahoe_full
	$self next pktTraceFile
}
Test/twodrops_tahoe_full instproc run {} {
        $self setup FullTcpTahoe {16 30}
}

Class Test/twodrops_reno -superclass TestSuite
Test/twodrops_reno instproc init {} {
	$self instvar net_ test_
	set net_	net4
	set test_	twodrops_reno
	$self next pktTraceFile
}
Test/twodrops_reno instproc run {} {
        $self setup Reno {14 28}
}

Class Test/twodrops_SA_reno -superclass TestSuite
Test/twodrops_SA_reno instproc init {} {
	$self instvar net_ test_
	set net_	net4
	set test_	twodrops_SA_reno
	Agent/TCP set singledup_ 1
	Test/twodrops_SA_reno instproc run {} [Test/twodrops_reno info instbody run ]
	$self next pktTraceFile
}

Class Test/twodrops_reno_full -superclass TestSuite
Test/twodrops_reno_full instproc init {} {
	$self instvar net_ test_
	set net_	net4
	set test_	twodrops_reno_full
	$self next pktTraceFile
}
Test/twodrops_reno_full instproc run {} {
        $self setup FullTcp {16 30}
}

Class Test/twodrops_newreno -superclass TestSuite
Test/twodrops_newreno instproc init {} {
	$self instvar net_ test_
	set net_	net4
	set test_	twodrops_newreno
	$self next pktTraceFile
}
Test/twodrops_newreno instproc run {} {
        $self setup Newreno {14 28}
}

Class Test/twodrops_SA_newreno -superclass TestSuite
Test/twodrops_SA_newreno instproc init {} {
	$self instvar net_ test_
	set net_	net4
	set test_	twodrops_SA_newreno
	Agent/TCP set singledup_ 1
	Test/twodrops_SA_newreno instproc run {} [Test/twodrops_newreno info instbody run ]
	$self next pktTraceFile
}

Class Test/twodrops_newreno_full -superclass TestSuite
Test/twodrops_newreno_full instproc init {} {
	$self instvar net_ test_
	set net_	net4
	set test_	twodrops_newreno_full
	$self next pktTraceFile
}
Test/twodrops_newreno_full instproc run {} {
        $self setup FullTcpNewreno {16 30}
}

Class Test/twodrops_sack -superclass TestSuite
Test/twodrops_sack instproc init {} {
	$self instvar net_ test_
	set net_	net4
	set test_	twodrops_sack
	$self next pktTraceFile
}
Test/twodrops_sack instproc run {} {
        $self setup Sack1 {14 28}
}

Class Test/twodrops_SA_sack -superclass TestSuite
Test/twodrops_SA_sack instproc init {} {
	$self instvar net_ test_
	set net_	net4
	set test_	twodrops_SA_sack
	Agent/TCP set singledup_ 1
	Test/twodrops_SA_sack instproc run {} [Test/twodrops_sack info instbody run ]
	$self next pktTraceFile
}

Class Test/twodrops_sack_full -superclass TestSuite
Test/twodrops_sack_full instproc init {} {
	$self instvar net_ test_
	set net_	net4
	set test_	twodrops_sack_full
	$self next pktTraceFile
}
Test/twodrops_sack_full instproc run {} {
        $self setup FullTcpSack1 {16 30}
}

Class Test/twodrops_fack -superclass TestSuite
Test/twodrops_fack instproc init {} {
	$self instvar net_ test_
	set net_	net4
	set test_	twodrops_fack
	$self next pktTraceFile
}
Test/twodrops_fack instproc run {} {
        $self setup Fack {14 28}
}

Class Test/twodrops_sackRH -superclass TestSuite
Test/twodrops_sackRH instproc init {} {
	$self instvar net_ test_
	set net_	net4
	set test_	twodrops_sackRH
	$self next pktTraceFile
}
Test/twodrops_sackRH instproc run {} {
        $self setup SackRH {14 28}
}

###################################################
## Three drops
###################################################

Class Test/threedrops_tahoe -superclass TestSuite
Test/threedrops_tahoe instproc init {} {
	$self instvar net_ test_
	set net_	net4
	set test_	threedrops_tahoe
	$self next pktTraceFile
}
Test/threedrops_tahoe instproc run {} {
        $self setup Tahoe {14 26 28}
}

Class Test/threedrops_SA_tahoe -superclass TestSuite
Test/threedrops_SA_tahoe instproc init {} {
	$self instvar net_ test_
	set net_	net4
	set test_	threedrops_SA_tahoe
	Agent/TCP set singledup_ 1
	Test/threedrops_SA_tahoe instproc run {} [Test/threedrops_tahoe info instbody run ]
	$self next pktTraceFile
}

Class Test/threedrops_tahoe_full -superclass TestSuite
Test/threedrops_tahoe_full instproc init {} {
	$self instvar net_ test_
	set net_	net4
	set test_	threedrops_tahoe_full
	$self next pktTraceFile
}
Test/threedrops_tahoe_full instproc run {} {
        $self setup FullTcpTahoe {16 28 30}
}

Class Test/threedrops_reno -superclass TestSuite
Test/threedrops_reno instproc init {} {
	$self instvar net_ test_
	set net_	net4
	set test_	threedrops_reno
	$self next pktTraceFile
}
Test/threedrops_reno instproc run {} {
        $self setup Reno {14 26 28}
}

Class Test/threedrops_SA_reno -superclass TestSuite
Test/threedrops_SA_reno instproc init {} {
	$self instvar net_ test_
	set net_	net4
	set test_	threedrops_SA_reno
	Agent/TCP set singledup_ 1
	Test/threedrops_SA_reno instproc run {} [Test/threedrops_reno info instbody run ]
	$self next pktTraceFile
}

Class Test/threedrops_reno_full -superclass TestSuite
Test/threedrops_reno_full instproc init {} {
	$self instvar net_ test_
	set net_	net4
	set test_	threedrops_reno_full
	$self next pktTraceFile
}
Test/threedrops_reno_full instproc run {} {
        $self setup FullTcp {16 28 30}
}

Class Test/threedrops_newreno -superclass TestSuite
Test/threedrops_newreno instproc init {} {
	$self instvar net_ test_
	set net_	net4
	set test_	threedrops_newreno
	$self next pktTraceFile
}
Test/threedrops_newreno instproc run {} {
        $self setup Newreno {14 26 28}
}

Class Test/threedrops_SA_newreno -superclass TestSuite
Test/threedrops_SA_newreno instproc init {} {
	$self instvar net_ test_
	set net_	net4
	set test_	threedrops_SA_newreno
	Agent/TCP set singledup_ 1
	Test/threedrops_SA_newreno instproc run {} [Test/threedrops_newreno info instbody run ]
	$self next pktTraceFile
}

Class Test/threedrops_newreno_full -superclass TestSuite
Test/threedrops_newreno_full instproc init {} {
	$self instvar net_ test_
	set net_	net4
	set test_	threedrops_newreno_full
	$self next pktTraceFile
}
Test/threedrops_newreno_full instproc run {} {
        $self setup FullTcpNewreno {16 28 30}
}

Class Test/threedrops_sack -superclass TestSuite
Test/threedrops_sack instproc init {} {
	$self instvar net_ test_
	set net_	net4
	set test_	threedrops_sack
	$self next pktTraceFile
}
Test/threedrops_sack instproc run {} {
        $self setup Sack1 {14 26 28}
}

Class Test/threedrops_SA_sack -superclass TestSuite
Test/threedrops_SA_sack instproc init {} {
	$self instvar net_ test_
	set net_	net4
	set test_	threedrops_SA_sack
	Agent/TCP set singledup_ 1
	Test/threedrops_SA_sack instproc run {} [Test/threedrops_sack info instbody run ]
	$self next pktTraceFile
}

Class Test/threedrops_sack_full -superclass TestSuite
Test/threedrops_sack_full instproc init {} {
	$self instvar net_ test_
	set net_	net4
	set test_	threedrops_sack_full
	$self next pktTraceFile
}
Test/threedrops_sack_full instproc run {} {
        $self setup FullTcpSack1 {16 28 30}
}

Class Test/threedrops_fack -superclass TestSuite
Test/threedrops_fack instproc init {} {
	$self instvar net_ test_
	set net_	net4
	set test_	threedrops_fack
	$self next pktTraceFile
}
Test/threedrops_fack instproc run {} {
        $self setup Fack {14 26 28}
}

Class Test/threedrops_sackRH -superclass TestSuite
Test/threedrops_sackRH instproc init {} {
	$self instvar net_ test_
	set net_	net4
	set test_	threedrops_sackRH
	$self next pktTraceFile
}
Test/threedrops_sackRH instproc run {} {
        $self setup SackRH {14 26 28}
}


###################################################
## Four drops
###################################################

Class Test/fourdrops_tahoe -superclass TestSuite
Test/fourdrops_tahoe instproc init {} {
	$self instvar net_ test_
	set net_	net4
	set test_	fourdrops_tahoe
	$self next pktTraceFile
}
Test/fourdrops_tahoe instproc run {} {
        $self setup Tahoe {14 24 26 28}
}

Class Test/fourdrops_SA_tahoe -superclass TestSuite
Test/fourdrops_SA_tahoe instproc init {} {
	$self instvar net_ test_
	set net_	net4
	set test_	fourdrops_SA_tahoe
	Agent/TCP set singledup_ 1
	Test/fourdrops_SA_tahoe instproc run {} [Test/fourdrops_tahoe info instbody run ]
	$self next pktTraceFile
}

Class Test/fourdrops_tahoe_full -superclass TestSuite
Test/fourdrops_tahoe_full instproc init {} {
	$self instvar net_ test_
	set net_	net4
	set test_	fourdrops_tahoe_full
	$self next pktTraceFile
}
Test/fourdrops_tahoe_full instproc run {} {
        $self setup FullTcpTahoe {16 26 28 30}
}

Class Test/fourdrops_reno -superclass TestSuite
Test/fourdrops_reno instproc init {} {
	$self instvar net_ test_
	set net_	net4
	set test_	fourdrops_reno
	$self next pktTraceFile
}
Test/fourdrops_reno instproc run {} {
        $self setup Reno {14 24 26 28}
}

Class Test/fourdrops_SA_reno -superclass TestSuite
Test/fourdrops_SA_reno instproc init {} {
	$self instvar net_ test_
	set net_	net4
	set test_	fourdrops_SA_reno
	Agent/TCP set singledup_ 1
	Test/fourdrops_SA_reno instproc run {} [Test/fourdrops_reno info instbody run ]
	$self next pktTraceFile
}

Class Test/fourdrops_reno_full -superclass TestSuite
Test/fourdrops_reno_full instproc init {} {
	$self instvar net_ test_
	set net_	net4
	set test_	fourdrops_reno_full
	$self next pktTraceFile
}
Test/fourdrops_reno_full instproc run {} {
        $self setup FullTcp {16 26 28 30}
}

Class Test/fourdrops_newreno -superclass TestSuite
Test/fourdrops_newreno instproc init {} {
	$self instvar net_ test_
	set net_	net4
	set test_	fourdrops_newreno
	$self next pktTraceFile
}
Test/fourdrops_newreno instproc run {} {
        $self setup Newreno {14 24 26 28}
}

Class Test/fourdrops_SA_newreno -superclass TestSuite
Test/fourdrops_SA_newreno instproc init {} {
	$self instvar net_ test_
	set net_	net4
	set test_	fourdrops_SA_newreno
	Agent/TCP set singledup_ 1
	Test/fourdrops_SA_newreno instproc run {} [Test/fourdrops_newreno info instbody run ]
	$self next pktTraceFile
}

Class Test/fourdrops_newreno_full -superclass TestSuite
Test/fourdrops_newreno_full instproc init {} {
	$self instvar net_ test_
	set net_	net4
	set test_	fourdrops_newreno_full
	$self next pktTraceFile
}
Test/fourdrops_newreno_full instproc run {} {
        $self setup FullTcpNewreno {16 26 28 30}
}

Class Test/fourdrops_sack -superclass TestSuite
Test/fourdrops_sack instproc init {} {
	$self instvar net_ test_
	set net_	net4
	set test_	fourdrops_sack
	$self next pktTraceFile
}
Test/fourdrops_sack instproc run {} {
        $self setup Sack1 {14 24 26 28}
}

Class Test/fourdrops_SA_sack -superclass TestSuite
Test/fourdrops_SA_sack instproc init {} {
	$self instvar net_ test_
	set net_	net4
	set test_	fourdrops_SA_sack
	Agent/TCP set singledup_ 1
	Test/fourdrops_SA_sack instproc run {} [Test/fourdrops_sack info instbody run ]
	$self next pktTraceFile
}

Class Test/fourdrops_sack_full -superclass TestSuite
Test/fourdrops_sack_full instproc init {} {
	$self instvar net_ test_
	set net_	net4
	set test_	fourdrops_sack_full
	$self next pktTraceFile
}
Test/fourdrops_sack_full instproc run {} {
        $self setup FullTcpSack1 {16 26 28 30}
}

Class Test/fourdrops_fack -superclass TestSuite
Test/fourdrops_fack instproc init {} {
	$self instvar net_ test_
	set net_	net4
	set test_	fourdrops_fack
	$self next pktTraceFile
}
Test/fourdrops_fack instproc run {} {
        $self setup Fack {14 24 26 28}
}
Class Test/fourdrops_sackRH -superclass TestSuite
Test/fourdrops_sackRH instproc init {} {
	$self instvar net_ test_
	set net_	net4
	set test_	fourdrops_sackRH
	$self next pktTraceFile
}
Test/fourdrops_sackRH instproc run {} {
        $self setup SackRH {14 24 26 28}
}

###################################################
## Multiple drops
###################################################

Class Test/multiple_tahoe -superclass TestSuite
Test/multiple_tahoe instproc init {} {
	$self instvar net_ test_
	set net_	net4
	set test_	multiple_tahoe
	$self next pktTraceFile
}
Test/multiple_tahoe instproc run {} {
        $self setup Tahoe {11 12 13 14 16 17 18 19 }
}

## This can result in an unnecessary packet transmission, unless the
## Limited Transmit option checks not to send packets less than maxseq_,
## the highest sequence number sent to far.
Class Test/multiple_SA_tahoe -superclass TestSuite
Test/multiple_SA_tahoe instproc init {} {
	$self instvar net_ test_
	set net_	net4
	set test_	multiple_SA_tahoe
	Agent/TCP set singledup_ 1
	Test/multiple_SA_tahoe instproc run {} [Test/multiple_tahoe info instbody run ]
	$self next pktTraceFile
}

Class Test/multiple_reno -superclass TestSuite
Test/multiple_reno instproc init {} {
	$self instvar net_ test_
	set net_	net4
	set test_	multiple_reno
	$self next pktTraceFile
}
Test/multiple_reno instproc run {} {
	$self setup Reno {11 12 13 14 16 17 18 19 }
}

Class Test/multiple_SA_reno -superclass TestSuite
Test/multiple_SA_reno instproc init {} {
	$self instvar net_ test_
	set net_	net4
	set test_	multiple_SA_reno
	Agent/TCP set singledup_ 1
	Test/multiple_SA_reno instproc run {} [Test/multiple_reno info instbody run ]
	$self next pktTraceFile
}

Class Test/multiple_newreno -superclass TestSuite
Test/multiple_newreno instproc init {} {
	$self instvar net_ test_
	set net_	net4
	set test_	multiple_newreno
	$self next pktTraceFile
}
Test/multiple_newreno instproc run {} {
	$self setup Newreno {11 12 13 14 16 17 18 19 }
}

Class Test/multiple_SA_newreno -superclass TestSuite
Test/multiple_SA_newreno instproc init {} {
	$self instvar net_ test_
	set net_	net4
	set test_	multiple_SA_newreno
	Agent/TCP set singledup_ 1
	Test/multiple_SA_newreno instproc run {} [Test/multiple_newreno info instbody run ]
	$self next pktTraceFile
}

Class Test/multiple_sack -superclass TestSuite
Test/multiple_sack instproc init {} {
	$self instvar net_ test_
	set net_	net4
	set test_	multiple_sack
	$self next pktTraceFile
}
Test/multiple_sack instproc run {} {
	$self setup Sack1 {11 12 13 14 16 17 18 19 } 
}

# Limited Transmit
Class Test/multiple_SA_sack -superclass TestSuite
Test/multiple_SA_sack instproc init {} {
	$self instvar net_ test_
	set net_	net4
	set test_	multiple_SA_sack
	Agent/TCP set singledup_ 1
	Test/multiple_SA_sack instproc run {} [Test/multiple_sack info instbody run ]
	$self next pktTraceFile
}

# Partial_ack 
Class Test/multiple_partial_ack_sack -superclass TestSuite
Test/multiple_partial_ack_sack instproc init {} {
	$self instvar net_ test_
	set net_	net4
	set test_	multiple_partial_ack_sack
	Agent/TCP set partial_ack_ 1
	Test/multiple_partial_ack_sack instproc run {} [Test/multiple_sack info instbody run ]
	$self next pktTraceFile
}

###################################################
## Multiple drops, scenario #2
###################################################

Class Test/multiple2_tahoe -superclass TestSuite
Test/multiple2_tahoe instproc init {} {
	$self instvar net_ test_
	set net_	net4
	set test_	multiple2_tahoe
	$self next pktTraceFile
}
Test/multiple2_tahoe instproc run {} {
        $self setup Tahoe {11 12 13 14 16 }
	# $self setup Tahoe {11 12 13 14 16 17 18 19 }
}

## This can result in an unnecessary packet transmission, unless the
## Limited Transmit option checks not to send packets less than maxseq_,
## the highest sequence number sent to far.
Class Test/multiple2_SA_tahoe -superclass TestSuite
Test/multiple2_SA_tahoe instproc init {} {
	$self instvar net_ test_
	set net_	net4
	set test_	multiple2_SA_tahoe
	Agent/TCP set singledup_ 1
	Test/multiple2_SA_tahoe instproc run {} [Test/multiple2_tahoe info instbody run ]
	$self next pktTraceFile
}

Class Test/multiple2_reno -superclass TestSuite
Test/multiple2_reno instproc init {} {
	$self instvar net_ test_
	set net_	net4
	set test_	multiple2_reno
	$self next pktTraceFile
}
Test/multiple2_reno instproc run {} {
	$self setup Reno {11 12 13 14 16 }
}

Class Test/multiple2_SA_reno -superclass TestSuite
Test/multiple2_SA_reno instproc init {} {
	$self instvar net_ test_
	set net_	net4
	set test_	multiple2_SA_reno
	Agent/TCP set singledup_ 1
	Test/multiple2_SA_reno instproc run {} [Test/multiple2_reno info instbody run ]
	$self next pktTraceFile
}

Class Test/multiple2_newreno -superclass TestSuite
Test/multiple2_newreno instproc init {} {
	$self instvar net_ test_
	set net_	net4
	set test_	multiple2_newreno
	$self next pktTraceFile
}
Test/multiple2_newreno instproc run {} {
	$self setup Newreno {11 12 13 14 16 }
}

Class Test/multiple2_SA_newreno -superclass TestSuite
Test/multiple2_SA_newreno instproc init {} {
	$self instvar net_ test_
	set net_	net4
	set test_	multiple2_SA_newreno
	Agent/TCP set singledup_ 1
	Test/multiple2_SA_newreno instproc run {} [Test/multiple2_newreno info instbody run ]
	$self next pktTraceFile
}

Class Test/multiple2_sack -superclass TestSuite
Test/multiple2_sack instproc init {} {
	$self instvar net_ test_
	set net_	net4
	set test_	multiple2_sack
	$self next pktTraceFile
}
Test/multiple2_sack instproc run {} {
	$self setup Sack1 {11 12 13 14 16 } 
}

# Limited Transmit
Class Test/multiple2_SA_sack -superclass TestSuite
Test/multiple2_SA_sack instproc init {} {
	$self instvar net_ test_
	set net_	net4
	set test_	multiple2_SA_sack
	Agent/TCP set singledup_ 1
	Test/multiple2_SA_sack instproc run {} [Test/multiple2_sack info instbody run ]
	$self next pktTraceFile
}

# Partial_ack 
# Because partial_ack is used, there is an unnecessary packet retransmission.
#  Partial_ack needs to be made smarter, not to retransmit a packet that
#  has just been sent?
Class Test/multiple2_partial_ack_sack -superclass TestSuite
Test/multiple2_partial_ack_sack instproc init {} {
	$self instvar net_ test_
	set net_	net4
	set test_	multiple2_partial_ack_sack
	Agent/TCP set partial_ack_ 1
	Test/multiple2_partial_ack_sack instproc run {} [Test/multiple2_sack info instbody run ]
	$self next pktTraceFile
}

TestSuite runTest
