# Copyright (c) 2001-2002 by the Protocol Engineering Lab, U of Delaware
# All rights reserved.
#
# Armando L. Caro Jr. <acaro@@cis,udel,edu>
# Janardhan Iyengar   <iyengar@@cis,udel,edu>
# Gerard J. Heinz II  <heinz@@cis,udel,edu>
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
#
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
#
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
#
# 3. Neither the name of the University nor of the Laboratory may be used
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
#
#
# To run all of the tests in this file: ./test-all-sctp
#
# To run an individual test:
#  ns test-suite-sctp.tcl sctp-2packetsTimeout
#  ns test-suite-sctp.tcl sctp-AMR-Exceeded
#  ns test-suite-sctp.tcl sctp-Rel1-Loss2 
#  ns test-suite-sctp.tcl sctp-burstAfterFastRtxRecovery 
#  ns test-suite-sctp.tcl sctp-burstAfterFastRtxRecovery-2 
#  ns test-suite-sctp.tcl sctp-cwndFreeze 
#  ns test-suite-sctp.tcl sctp-cwndFreeze-multistream 
#  ns test-suite-sctp.tcl sctp-hugeRwnd 
#  ns test-suite-sctp.tcl sctp-initRtx 
#  ns test-suite-sctp.tcl sctp-multihome1-2 
#  ns test-suite-sctp.tcl sctp-multihome2-1
#  ns test-suite-sctp.tcl sctp-multihome2-2AMR-Exceeded
#  ns test-suite-sctp.tcl sctp-multihome2-2Failover 
#  ns test-suite-sctp.tcl sctp-multihome2-2Failover0
#  ns test-suite-sctp.tcl sctp-multihome2-2Failover1
#  ns test-suite-sctp.tcl sctp-multihome2-2Rtx1  
#  ns test-suite-sctp.tcl sctp-multihome2-2Rtx3 
#  ns test-suite-sctp.tcl sctp-multihome2-2Timeout
#  ns test-suite-sctp.tcl sctp-multihome2-R-2
#  ns test-suite-sctp.tcl sctp-multihome3-3Timeout
#  ns test-suite-sctp.tcl sctp-multipleDropsSameWnd-1 
#  ns test-suite-sctp.tcl sctp-multipleDropsSameWnd-1-delayed 
#  ns test-suite-sctp.tcl sctp-multipleDropsSameWnd-2 
#  ns test-suite-sctp.tcl sctp-multipleDropsSameWnd-3 
#  ns test-suite-sctp.tcl sctp-multipleDropsTwoWnds-1-delayed 
#  ns test-suite-sctp.tcl sctp-multipleRtx 
#  ns test-suite-sctp.tcl sctp-multipleRtx-early 
#  ns test-suite-sctp.tcl sctp-noEarlyHBs
#  ns test-suite-sctp.tcl sctp-smallRwnd 
#  ns test-suite-sctp.tcl sctp-zeroRtx 
#  ns test-suite-sctp.tcl sctp-zeroRtx-burstLoss 
#
#  ns test-suite-sctp.tcl sctp-hbAfterRto-2packetsTimeout
#  ns test-suite-sctp.tcl sctp-hbAfterRto-multihome2-2Timeout
#
#  ns test-suite-sctp.tcl sctp-multipleFastRtx-2packetsTimeout
#  ns test-suite-sctp.tcl sctp-multipleFastRtx-multihome2-2Timeout
#
#  ns test-suite-sctp.tcl sctp-newReno
#
#  ns test-suite-sctp.tcl sctp-timestamp-multihome2-2Rtx3
#  ns test-suite-sctp.tcl sctp-timestamp-multihome2-2Timeout

Class TestSuite

# 2 packets get dropped and their fast rtx gets lost too.... forcing them
# to timeout.
Class Test/sctp-2packetsTimeout -superclass TestSuite

# This script tests that the appropriate action is taken when the 
# Association.Max.Retrans exceeded... abruptly close the association!
Class Test/sctp-AMR-Exceeded -superclass TestSuite

# tests unreliable stream with k-rtx value of 1 with 2 losses of same chunk.
Class Test/sctp-Rel1-Loss2 -superclass TestSuite

# This tests the Max.Burst feature added in the SCTP implementors
# guide draft v4.  This script carefully choose a small receiver window
# and drops a specific packet to generate the scenario where the
# receiver has a full window and is waiting on the rtx of an earlier
# lost chunk. Once the sender fast retransmits the chunk and the
# receiver receives it, the entire receiver window is free'd up and
# now the sender has plenty of room to send. This WOULD create a
# burst, but Max.Burst limits the burst in this scenario.
Class Test/sctp-burstAfterFastRtxRecovery -superclass TestSuite

# This tests the Max.Burst feature added in the SCTP implementors
# guide draft v4.  This script carefully choose a small receiver window
# and drops a specific packet to generate the scenario where the
# receiver has a full window and is waiting on the rtx of an earlier
# lost chunk. Once the sender fast retransmits the chunk and the
# receiver receives it, the entire receiver window is free'd up and
# now the sender has plenty of room to send. This WOULD create a
# burst, but Max.Burst limits the burst in this scenario.  
Class Test/sctp-burstAfterFastRtxRecovery-2 -superclass TestSuite

# The SCTP implementor's guide clarifies a point in the congestion
# control algorithm which allows PTMU-1 bytes over cwnd in
# flight. This script tests that it is done properly and that cwnd
# does NOT freeze.
Class Test/sctp-cwndFreeze -superclass TestSuite

# The SCTP implementor's guide clarifies a point in the congestion control
# algorithm which allows PTMU-1 bytes over cwnd in flight. This script
# tests that it is done properly (with multistreams) and that cwnd does
# NOT freeze.
Class Test/sctp-cwndFreeze-multistream -superclass TestSuite

# This script tests for proper behavior when using a huge rwnd and mtu
# size chunks.
Class Test/sctp-hugeRwnd -superclass TestSuite

# tests that it recovers from losing an INIT chunk
Class Test/sctp-initRtx -superclass TestSuite

# Demonstrates multihoming. One endpoint is single homed while the
# other is multihomed. Shows that the 2 can be combined. The sender is
# multihomed.
Class Test/sctp-multihome1-2 -superclass TestSuite

# Demonstrates multihoming. One endpoint is single homed while the other is
# multihomed. Shows that the 2 can be combined. The receiver is multihomed.
Class Test/sctp-multihome2-1 -superclass TestSuite

# This script tests that the appropriate action is taken when the association
# is multihomed and Association.Max.Retrans exceeded... abruptly close the 
# association!
Class Test/sctp-multihome2-2AMR-Exceeded -superclass TestSuite

# Demonstrates a failover with multihoming (using a heartbeat timer per
# dest). Two endpoints with 2 interfaces with direct connections between
# each pair. Eventually in the primary becomes active again and all
# traffic moves back to the primary.
Class Test/sctp-multihome2-2Failover -superclass TestSuite

# Demonstrates a failover with multihoming, but this example has
# heartbeating turned off. Two endpoints with 2 interfaces with direct
# connections between each pair. Eventually in the primary becomes active
# again, but since heartbeating is turned off, traffic never moves back to
# the primary.
Class Test/sctp-multihome2-2Failover0 -superclass TestSuite

# Demonstrates a failover with multihoming (using one heartbeat timer for
# all dests). Two endpoints with 2 interfaces with direct connections
# between each pair. Eventually in the primary becomes active again and
# all traffic moves back to the primary.
Class Test/sctp-multihome2-2Failover1 -superclass TestSuite

# Demonstrates retransmissions with multihoming. Two endpoints with 2
# interfaces with direct connections between each pair. A packet gets
# dropped and later gets retransmitted on an alternate path.
Class Test/sctp-multihome2-2Rtx1 -superclass TestSuite

# Demonstrates retransmissions with multihoming. Two endpoints with 2
# interfaces with direct connections between each pair. 3 packets get
# dropped and later get retransmitted on an alternate path.
Class Test/sctp-multihome2-2Rtx3 -superclass TestSuite

# Demonstrates retransmissions with multihoming. Two endpoints with 2
# interfaces with direct connections between each pair. A packet gets
# dropped and fast rtx'd on the alternate path. The retransmit gets
# lost and times out, causing yet another retransmission.
Class Test/sctp-multihome2-2Timeout -superclass TestSuite

# Demonstrates multihoming. Two endpoints with 2 interfaces each all
# connected via a router. In the middle of the association, a change
# primary is done.
Class Test/sctp-multihome2-R-2 -superclass TestSuite

# Demonstrates retransmissions with multihoming. Two endpoints with 3
# interfaces with direct connections between each pair. A packet gets dropped 
# and fast rtx'd on the alternate path. The retransmit gets lost and times out,
# causing a retransmission on the the third althernate path.
Class Test/sctp-multihome3-3Timeout -superclass TestSuite

# One burst loss and one individual loss in same window (without delayed sacks).
Class Test/sctp-multipleDropsSameWnd-1 -superclass TestSuite

# One burst loss and one individual loss in same window (with delayed sacks).
Class Test/sctp-multipleDropsSameWnd-1-delayed -superclass TestSuite

# Burst loss in same window.
Class Test/sctp-multipleDropsSameWnd-2 -superclass TestSuite

# Two independent burst losses in same window.
Class Test/sctp-multipleDropsSameWnd-3 -superclass TestSuite

# One continuous burst loss.
Class Test/sctp-multipleDropsTwoWnds-1-delayed -superclass TestSuite

# This test drops TSN 15 (ns pkt 16) and the Fast Rtx of the same
# (ns pkt 35).  According to the proposed Section 7.2.4.5, Fast Rtx
# happens only once for any TSN. This graph illustrates this point -
# if Fast Rtx is enabled after the timeout rtx of the TSN, it can be
# clearly seen that there WILL be a false Fast Rtx for the TSN.
Class Test/sctp-multipleRtx -superclass TestSuite

# This test drops TSN 3 (ns pkt 4) and the Fast Rtx of the same (ns
# pkt 11).  According to the proposed Section 7.2.4.5, Fast Rtx
# happens only once for any TSN. This graph illustrates this point -
# if Fast Rtx is enabled after the timeout rtx of the TSN, it can be
# clearly seen that there WILL be a false Fast Rtx for the TSN. (Note:
# this script is basically the same as multipleRtx.tcl, except here we
# are testing the same condition when it happens early in the
# connection.)
Class Test/sctp-multipleRtx-early -superclass TestSuite

# test that HEARTBEATs don't start until the association is established
Class Test/sctp-noEarlyHBs -superclass TestSuite

# This script tests for proper behavior when using a small rwnd and
# medium size chunks.
Class Test/sctp-smallRwnd -superclass TestSuite

# tests unreliable stream with k-rtx value of 0 with one loss.
Class Test/sctp-zeroRtx -superclass TestSuite

# test unreliable stream with k-rtx value of 0 with a burst loss.
Class Test/sctp-zeroRtx-burstLoss -superclass TestSuite


# Test HbAfterRto extension. 2 packets get dropped and their fast rtx gets
# lost too.... forcing them to timeout.
Class Test/sctp-hbAfterRto-2packetsTimeout -superclass TestSuite

# Test HbAfterRto extension. Demonstrates retransmissions with
# multihoming. Two endpoints with 2 interfaces with direct connections
# between each pair. A packet gets dropped and fast rtx'd on the alternate
# path. The retransmit gets lost and times out, causing a retransmission
# on the original path (primary).
Class Test/sctp-hbAfterRto-multihome2-2Timeout -superclass TestSuite


# Test MultipleFastRtx extension. 2 packets get dropped and their fast rtx gets
# lost too.... forcing them to timeout.
Class Test/sctp-multipleFastRtx-2packetsTimeout -superclass TestSuite

# Test MultipleFastRtx extension. Demonstrates retransmissions with
# multihoming. Two endpoints with 2 interfaces with direct connections
# between each pair. A packet gets dropped and fast rtx'd on the alternate
# path. The retransmit gets lost and times out, causing a retransmission
# on the original path (primary).
Class Test/sctp-multipleFastRtx-multihome2-2Timeout -superclass TestSuite


# Test NewReno extension.
Class Test/sctp-newReno -superclass TestSuite


# Test Timestamp extension. Demonstrates retransmissions with timestamps
# and multihoming. Two endpoints with 2 interfaces with direct connections
# between each pair. 3 packets get dropped and later get retransmitted on
# an alternate path.
Class Test/sctp-timestamp-multihome2-2Rtx3 -superclass TestSuite

# Test Timestamp extension. Demonstrates retransmissions with
# multihoming. Two endpoints with 2 interfaces with direct connections
# between each pair. A packet gets dropped and fast rtx'd on the alternate
# path. The retransmit gets lost and times out, causing a retransmission
# on the original path (primary).
Class Test/sctp-timestamp-multihome2-2Timeout -superclass TestSuite


proc usage {} {
    global argv0
    puts stderr "usage: ns $argv0 <test> "
    exit 1
}

TestSuite instproc init {} {
    Trace set show_sctphdr_ 1
    $self instvar ns numnodes_
    set ns [new Simulator]
    set allchan [open temp.rands w]
    $ns trace-all $allchan
}

TestSuite instproc finish {} {
    $self instvar ns
    global quiet PERL
 
    $ns flush-trace
    if {$quiet == 0} {
        puts "Graphing..."
        set XGRAPH "../../../bin/xgraph"
        set RAW2XG_SCTP "../../bin/raw2xg-sctp"
        set WRAP 100
	exec $PERL $RAW2XG_SCTP -A -f -q -s 0.01 -m $WRAP -n 0 temp.rands \
		> temp.rands.points
        exec $XGRAPH -bb -tk -nl -m -x time -y packets temp.rands.points &
    }
    exit 0
}

Test/sctp-2packetsTimeout instproc init {} {
    $self instvar ns ftp0
    global quiet 
    set testName 2packetsTimeout
    $self next

    set n0 [$ns node]
    set n1 [$ns node]
    $ns duplex-link $n0 $n1 .5Mb 200ms DropTail
    $ns duplex-link-op $n0 $n1 orient right

    set err [new ErrorModel/List]
    $err droplist {14 15 31 32}
    $ns lossmodel $err $n0 $n1

    set sctp0 [new Agent/SCTP]
    $ns attach-agent $n0 $sctp0
    $sctp0 set mtu_ 1500
    $sctp0 set dataChunkSize_ 1468
    $sctp0 set numOutStreams_ 1

    if {$quiet == 0} {
	$sctp0 set debugMask_ -1 
	$sctp0 set debugFileIndex_ 0
    }

    set sctp1 [new Agent/SCTP]
    $ns attach-agent $n1 $sctp1
    $sctp1 set mtu_ 1500
    $sctp1 set initialRwnd_ 131072 
    $sctp1 set useDelayedSacks_ 0
    
    if {$quiet == 0} {
	$sctp1 set debugMask_ -1
	$sctp1 set debugFileIndex_ 1
    }

    $ns connect $sctp0 $sctp1

    set ftp0 [new Application/FTP]
    $ftp0 attach-agent $sctp0
}

Test/sctp-2packetsTimeout instproc run {} {
    $self instvar ns ftp0
    $ns at 0.5 "$ftp0 start"
    $ns at 10.0 "$self finish"
    
    $ns run
}

Test/sctp-AMR-Exceeded instproc init {} {
    $self instvar ns testName ftp0
    global quiet
    set testName AMR-Exceeded
    $self next

    set n0 [$ns node]
    set n1 [$ns node]
    $ns duplex-link $n0 $n1 .5Mb 200ms DropTail
    $ns duplex-link-op $n0 $n1 orient right


    set err [new ErrorModel/List]
    $err droplist {14 15 16 17 18 19 20 21 22 23 31 32 33 34 35 36 37 38 39 40 41 42 43}
    $ns lossmodel $err $n0 $n1

    set sctp0 [new Agent/SCTP]
    $ns attach-agent $n0 $sctp0
    $sctp0 set mtu_ 1500
    $sctp0 set dataChunkSize_ 1468 
    $sctp0 set numOutStreams_ 1
    $sctp0 set associationMaxRetrans_ 5

    if {$quiet == 0} {
	$sctp0 set debugMask_ -1 
	$sctp0 set debugFileIndex_ 0

	set trace_ch [open trace.sctp w]
	$sctp0 set trace_all_ 1
	$sctp0 trace cwnd_
	$sctp0 trace rto_
	$sctp0 trace errorCount_
	$sctp0 attach $trace_ch
    }

    set sctp1 [new Agent/SCTP]
    $ns attach-agent $n1 $sctp1
    $sctp1 set mtu_ 1500
    $sctp1 set initialRwnd_ 131072 
    $sctp1 set useDelayedSacks_ 0

    if {$quiet == 0} {
	$sctp1 set debugMask_ -1
	$sctp1 set debugFileIndex_ 1
    }

    $ns connect $sctp0 $sctp1

    set ftp0 [new Application/FTP]
    $ftp0 attach-agent $sctp0
}

Test/sctp-AMR-Exceeded instproc run {} {
    $self instvar ns ftp0
    $ns at 0.5 "$ftp0 start"
    $ns at 90.0 "$self finish"
    
    $ns run
}

Test/sctp-Rel1-Loss2 instproc init {} {
    $self instvar ns testName ftp0
    global quiet
    set testName Rel1-Loss2
    $self next

    set n0 [$ns node]
    set n1 [$ns node]
    $ns duplex-link $n0 $n1 .5Mb 200ms DropTail
    $ns duplex-link-op $n0 $n1 orient right
    
    set err [new ErrorModel/List]
    
    $err droplist {15 28}
    
    $ns lossmodel $err $n0 $n1
    
    set sctp0 [new Agent/SCTP]
    $ns attach-agent $n0 $sctp0
    $sctp0 set mtu_ 1500
    $sctp0 set dataChunkSize_ 1468
    $sctp0 set numOutStreams_ 1
    $sctp0 set numUnrelStreams_ 1
    $sctp0 set reliability_ 1

    if {$quiet == 0} {
	$sctp0 set debugMask_ -1 
	$sctp0 set debugFileIndex_ 0

	set trace_ch [open trace.sctp w]
	$sctp0 set trace_all_ 1
	$sctp0 trace cwnd_
	$sctp0 trace rto_
	$sctp0 trace errorCount_
	$sctp0 attach $trace_ch
    }
    
    set sctp1 [new Agent/SCTP]
    $ns attach-agent $n1 $sctp1
    $sctp1 set mtu_ 1500
    $sctp1 set initialRwnd_ 131072
    $sctp1 set useDelayedSacks_ 1
    
    if {$quiet == 0} {
	$sctp1 set debugMask_ -1
	$sctp1 set debugFileIndex_ 1
    }

    $ns connect $sctp0 $sctp1
    
    set ftp0 [new Application/FTP]
    $ftp0 attach-agent $sctp0   
}

Test/sctp-Rel1-Loss2 instproc run {} {
    $self instvar ns ftp0
    $ns at 0.5 "$ftp0 start"
    $ns at 10.0 "$self finish"
    
    $ns run
}


Test/sctp-burstAfterFastRtxRecovery instproc init {} {
    $self instvar ns testName ftp0
    global quiet
    set testName burstAfterFastRtxRecovery

    $self next
    set n0 [$ns node]
    set n1 [$ns node]
    $ns duplex-link $n0 $n1 5Mb 50ms DropTail
    $ns duplex-link-op $n0 $n1 orient right
    
    set err [new ErrorModel/List]
    $err droplist {112}
    $ns lossmodel $err $n0 $n1
    
    set sctp0 [new Agent/SCTP]
    $ns attach-agent $n0 $sctp0
    $sctp0 set mtu_ 1500
    $sctp0 set dataChunkSize_ 1468
    $sctp0 set numOutStreams_ 1
    $sctp0 set useMaxBurst_ 1
    
    if {$quiet == 0} {
	$sctp0 set debugMask_ -1 
	$sctp0 set debugFileIndex_ 0

	set trace_ch [open trace.sctp w]
	$sctp0 set trace_all_ 1
	$sctp0 trace cwnd_
	$sctp0 trace rto_
	$sctp0 trace errorCount_
	$sctp0 attach $trace_ch
    }

    set sctp1 [new Agent/SCTP]
    $ns attach-agent $n1 $sctp1
    $sctp1 set mtu_ 1500
    $sctp1 set initialRwnd_ 23488 
    $sctp1 set useDelayedSacks_ 1
    
    if {$quiet == 0} {
	$sctp1 set debugMask_ -1
	$sctp1 set debugFileIndex_ 1
    }

    $ns connect $sctp0 $sctp1
    
    set ftp0 [new Application/FTP]
    $ftp0 attach-agent $sctp0
}

Test/sctp-burstAfterFastRtxRecovery instproc run {} {
    $self instvar ns ftp0
    $ns at 0.5 "$ftp0 start"
    $ns at 5.0 "$self finish"
    $ns run
}

Test/sctp-burstAfterFastRtxRecovery-2 instproc init {} {
    $self instvar ns testName ftp0
    global quiet
    set testName burstAfterFastRtxRecovery-2
    $self next

    set n0 [$ns node]
    set n1 [$ns node]
    $ns duplex-link $n0 $n1 .5Mb 200ms DropTail
    $ns duplex-link-op $n0 $n1 orient right
    
    set err [new ErrorModel/List]
    $err droplist {31}
    $ns lossmodel $err $n0 $n1
    
    set sctp0 [new Agent/SCTP]
    $ns attach-agent $n0 $sctp0
    $sctp0 set mtu_ 1500
    $sctp0 set dataChunkSize_ 1468
    $sctp0 set numOutStreams_ 1
    $sctp0 set useMaxBurst_ 1

    if {$quiet == 0} {
	$sctp0 set debugMask_ -1 
	$sctp0 set debugFileIndex_ 0

	set trace_ch [open trace.sctp w]
	$sctp0 set trace_all_ 1
	$sctp0 trace cwnd_
	$sctp0 trace rto_
	$sctp0 trace errorCount_
	$sctp0 attach $trace_ch
    }
    
    set sctp1 [new Agent/SCTP]
    $ns attach-agent $n1 $sctp1
    $sctp1 set mtu_ 1500
    $sctp1 set initialRwnd_ 23488
    $sctp1 set useDelayedSacks_ 1
    
    if {$quiet == 0} {
	$sctp1 set debugMask_ -1
	$sctp1 set debugFileIndex_ 1
    }

    $ns connect $sctp0 $sctp1
    
    set ftp0 [new Application/FTP]
    $ftp0 attach-agent $sctp0
}

Test/sctp-burstAfterFastRtxRecovery-2 instproc run {} {
    $self instvar ns ftp0
    $ns at 0.5 "$ftp0 start"
    $ns at 6.0 "$self finish"
    $ns run
}

Test/sctp-cwndFreeze instproc init {} {
    $self instvar ns testName ftp0
    global quiet
    set testName cwndFreeze
    $self next

    set n0 [$ns node]
    set n1 [$ns node]
    $ns duplex-link $n0 $n1 .5Mb 200ms DropTail
    $ns duplex-link-op $n0 $n1 orient right
    
    set err [new ErrorModel/List]
    $err droplist {15}
    $ns lossmodel $err $n0 $n1
    
    set sctp0 [new Agent/SCTP]
    $ns attach-agent $n0 $sctp0
    $sctp0 set mtu_ 1500
    $sctp0 set dataChunkSize_ 1468 
    $sctp0 set numOutStreams_ 1

    if {$quiet == 0} {
	$sctp0 set debugMask_ -1 
	$sctp0 set debugFileIndex_ 0

	set trace_ch [open trace.sctp w]
	$sctp0 set trace_all_ 1
	$sctp0 trace cwnd_
	$sctp0 trace rto_
	$sctp0 trace errorCount_
	$sctp0 attach $trace_ch
    }
    
    set sctp1 [new Agent/SCTP]
    $ns attach-agent $n1 $sctp1
    $sctp1 set mtu_ 1500
    $sctp1 set initialRwnd_ 131072
    $sctp1 set useDelayedSacks_ 0
    
    if {$quiet == 0} {
	$sctp1 set debugMask_ -1
	$sctp1 set debugFileIndex_ 1
    }

    $ns connect $sctp0 $sctp1
    
    set ftp0 [new Application/FTP]
    $ftp0 attach-agent $sctp0
}

Test/sctp-cwndFreeze instproc run {} {
    $self instvar ns ftp0
    $ns at 0.5 "$ftp0 start"
    $ns at 5.0 "$self finish"
    $ns run
}

Test/sctp-cwndFreeze-multistream instproc init {} {
    $self instvar ns testName ftp0
    global quiet
    set testName cwndFreeze-multistream
    $self next

    set n0 [$ns node]
    set n1 [$ns node]
    $ns duplex-link $n0 $n1 .5Mb 200ms DropTail
    $ns duplex-link-op $n0 $n1 orient right
    
    set err [new ErrorModel/List]
    $err droplist {15}
    $ns lossmodel $err $n0 $n1
    
    set sctp0 [new Agent/SCTP]
    $ns attach-agent $n0 $sctp0
    $sctp0 set mtu_ 1500
    $sctp0 set dataChunkSize_ 1468 
    $sctp0 set numOutStreams_ 5

    if {$quiet == 0} {
	$sctp0 set debugMask_ -1 
	$sctp0 set debugFileIndex_ 0

	set trace_ch [open trace.sctp w]
	$sctp0 set trace_all_ 1
	$sctp0 trace cwnd_
	$sctp0 trace rto_
	$sctp0 trace errorCount_
	$sctp0 attach $trace_ch
    }
    
    set sctp1 [new Agent/SCTP]
    $ns attach-agent $n1 $sctp1
    $sctp1 set mtu_ 1500
    $sctp1 set initialRwnd_ 131072
    $sctp1 set useDelayedSacks_ 1
    
    if {$quiet == 0} {
	$sctp1 set debugMask_ -1
	$sctp1 set debugFileIndex_ 1
    }

    $ns connect $sctp0 $sctp1
    
    set ftp0 [new Application/FTP]
    $ftp0 attach-agent $sctp0    
}

Test/sctp-cwndFreeze-multistream instproc run {} {
    $self instvar ns ftp0
    $ns at 0.5 "$ftp0 start"
    $ns at 10.0 "$self finish"
    
    $ns run
}

Test/sctp-hugeRwnd instproc init {} {
    $self instvar ns testName ftp0
    global quiet
    set testName hugeRwnd
    $self next

    set n0 [$ns node]
    set n1 [$ns node]
    $ns duplex-link $n0 $n1 1500Mb 300ms DropTail
    $ns duplex-link-op $n0 $n1 orient right
    $ns queue-limit $n0 $n1 10000
    
    set err [new ErrorModel/List]
    
    set sctp0 [new Agent/SCTP]
    $ns attach-agent $n0 $sctp0
    $sctp0 set mtu_ 1500
    $sctp0 set dataChunkSize_ 1468
    $sctp0 set numOutStreams_ 1
    
    if {$quiet == 0} {
	$sctp0 set debugMask_ -1 
	$sctp0 set debugFileIndex_ 0

	set trace_ch [open trace.sctp w]
	$sctp0 set trace_all_ 1
	$sctp0 trace cwnd_
	$sctp0 trace rto_
	$sctp0 trace errorCount_
	$sctp0 attach $trace_ch
    }

    set sctp1 [new Agent/SCTP]
    $ns attach-agent $n1 $sctp1
    $sctp1 set mtu_ 1500
    $sctp1 set initialRwnd_ 1048576
    $sctp1 set useDelayedSacks_ 0
    
    if {$quiet == 0} {
	$sctp1 set debugMask_ -1
	$sctp1 set debugFileIndex_ 1
    }

    $ns connect $sctp0 $sctp1
    
    set ftp0 [new Application/FTP]
    $ftp0 attach-agent $sctp0
}

Test/sctp-hugeRwnd instproc run {} {
    $self instvar ns ftp0
    $ns at 0.5 "$ftp0 start"
    $ns at 10.0 "$self finish"
    $ns run
}

Test/sctp-initRtx instproc init {} {
    $self instvar ns testName ftp0
    global quiet
    set testName initRtx
    $self next

    set n0 [$ns node]
    set n1 [$ns node]
    $ns duplex-link $n0 $n1 .5Mb 200ms DropTail
    $ns duplex-link-op $n0 $n1 orient right
    
    set err [new ErrorModel/List]
    $err droplist {0}
    $ns lossmodel $err $n0 $n1
    
    set sctp0 [new Agent/SCTP]
    $ns attach-agent $n0 $sctp0
    $sctp0 set mtu_ 1500
    $sctp0 set dataChunkSize_ 1468 
    $sctp0 set numOutStreams_ 1

    if {$quiet == 0} {
	$sctp0 set debugMask_ -1 
	$sctp0 set debugFileIndex_ 0

	set trace_ch [open trace.sctp w]
	$sctp0 set trace_all_ 1
	$sctp0 trace cwnd_
	$sctp0 trace rto_
	$sctp0 trace errorCount_
	$sctp0 attach $trace_ch
    }

    set sctp1 [new Agent/SCTP]
    $ns attach-agent $n1 $sctp1
    $sctp1 set mtu_ 1500
    $sctp1 set initialRwnd_ 131072 
    $sctp1 set useDelayedSacks_ 1
    
    if {$quiet == 0} {
	$sctp1 set debugMask_ -1
	$sctp1 set debugFileIndex_ 1
    }
    
    $ns connect $sctp0 $sctp1
    
    set ftp0 [new Application/FTP]
    $ftp0 attach-agent $sctp0
    
}

Test/sctp-initRtx instproc run {} {
    $self instvar ns ftp0
    $ns at 0.5 "$ftp0 start"
    $ns at 10.0 "$self finish"
    $ns run
}

Test/sctp-multihome1-2 instproc init {} {
    $self instvar ns testName host0_if1 sctp0 ftp0
    global quiet
    set testName multihome1-2
    $self next

    set host0_core [$ns node]
    set host0_if0 [$ns node]
    set host0_if1 [$ns node]
    $host0_core color Red
    $host0_if0 color Red
    $host0_if1 color Red
    $ns multihome-add-interface $host0_core $host0_if0
    $ns multihome-add-interface $host0_core $host0_if1
    
    set host1 [$ns node]
    $host1 color Blue
    
    set router [$ns node]
    
    $ns duplex-link $host0_if0 $router .5Mb 200ms DropTail
    $ns duplex-link $host0_if1 $router .5Mb 200ms DropTail
    
    $ns duplex-link $host1 $router .5Mb 200ms DropTail
    
    set sctp0 [new Agent/SCTP]
    $ns multihome-attach-agent $host0_core $sctp0
    $sctp0 set mtu_ 1500
    $sctp0 set dataChunkSize_ 1468 
    $sctp0 set numOutStreams_ 1
    
    if {$quiet == 0} {
	$sctp0 set debugMask_ -1 
	$sctp0 set debugFileIndex_ 0

	set trace_ch [open trace.sctp w]
	$sctp0 set trace_all_ 1
	$sctp0 trace cwnd_
	$sctp0 trace rto_
	$sctp0 trace errorCount_
	$sctp0 attach $trace_ch
    }

    set sctp1 [new Agent/SCTP]
    $ns attach-agent $host1 $sctp1
    $sctp1 set mtu_ 1500
    $sctp1 set initialRwnd_ 131072
    $sctp1 set useDelayedSacks_ 1
    
    if {$quiet == 0} {
	$sctp1 set debugMask_ -1
	$sctp1 set debugFileIndex_ 1
    }
    
    $ns connect $sctp0 $sctp1
    
    set ftp0 [new Application/FTP]
    $ftp0 attach-agent $sctp0
}

Test/sctp-multihome1-2 instproc run {} {
    $self instvar ns host0_if1 sctp0 ftp0
    $ns at 6.0 "$sctp0 force-source $host0_if1"
    $ns at 0.5 "$ftp0 start"
    $ns at 8.0 "$self finish"
    $ns run
}

Test/sctp-multihome2-1 instproc init {} {
    $self instvar ns testName host0_if1 sctp1 ftp1
    global quiet
    set testName multihome2-1
    $self next

    set host0_core [$ns node]
    set host0_if0 [$ns node]
    set host0_if1 [$ns node]
    $host0_core color Red
    $host0_if0 color Red
    $host0_if1 color Red
    $ns multihome-add-interface $host0_core $host0_if0
    $ns multihome-add-interface $host0_core $host0_if1

    set host1 [$ns node]
    $host1 color Blue

    set router [$ns node]

    $ns duplex-link $host0_if0 $router .5Mb 200ms DropTail
    $ns duplex-link $host0_if1 $router .5Mb 200ms DropTail

    $ns duplex-link $host1 $router .5Mb 200ms DropTail

    set sctp0 [new Agent/SCTP]
    $ns multihome-attach-agent $host0_core $sctp0
    $sctp0 set mtu_ 1500
    $sctp0 set dataChunkSize_ 1468
    $sctp0 set numOutStreams_ 1
    $sctp0 set oneHeartbeatTimer_ 1

    if {$quiet == 0} {
	$sctp0 set debugMask_ -1 
	$sctp0 set debugFileIndex_ 0

	set trace_ch [open trace.sctp w]
	$sctp0 set trace_all_ 1
	$sctp0 trace cwnd_
	$sctp0 trace rto_
	$sctp0 trace errorCount_
	$sctp0 attach $trace_ch
    }

    set sctp1 [new Agent/SCTP]
    $ns attach-agent $host1 $sctp1
    $sctp1 set mtu_ 1500
    $sctp1 set dataChunkSize_ 512
    $sctp1 set initialRwnd_ 131072 
    $sctp1 set useDelayedSacks_ 1
    
    if {$quiet == 0} {
	$sctp1 set debugMask_ -1
	$sctp1 set debugFileIndex_ 1
    }

    $ns connect $sctp0 $sctp1
    $sctp1 set-primary-destination $host0_if0

    set ftp1 [new Application/FTP]
    $ftp1 attach-agent $sctp1
}

Test/sctp-multihome2-1 instproc run {} {
    $self instvar ns host0_if1 sctp1 ftp1
    $ns at 6.0 "$sctp1 set-primary-destination $host0_if1"
    $ns at 0.5 "$ftp1 start"
    $ns at 8.0 "$self finish"
    $ns run
}

Test/sctp-multihome2-2AMR-Exceeded instproc init {} {
    $self instvar ns testName ftp0
    global quiet
    set testName multihome2-2AMR-Exceeded
    $self next
    
    set host0_core [$ns node]
    set host0_if0 [$ns node]
    set host0_if1 [$ns node]
    $host0_core color Red
    $host0_if0 color Red
    $host0_if1 color Red
    $ns multihome-add-interface $host0_core $host0_if0
    $ns multihome-add-interface $host0_core $host0_if1

    set host1_core [$ns node]
    set host1_if0 [$ns node]
    set host1_if1 [$ns node]
    $host1_core color Blue
    $host1_if0 color Blue
    $host1_if1 color Blue
    $ns multihome-add-interface $host1_core $host1_if0
    $ns multihome-add-interface $host1_core $host1_if1

    $ns duplex-link $host0_if0 $host1_if0 .5Mb 200ms DropTail
    $ns duplex-link $host0_if1 $host1_if1 .5Mb 200ms DropTail

    set err0 [new ErrorModel/List]
    $err0 droplist {15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37} 
    $ns lossmodel $err0 $host0_if0 $host1_if0

    set err1 [new ErrorModel/List]
    $err1 droplist {0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15}
    $ns lossmodel $err1 $host0_if1 $host1_if1

    set sctp0 [new Agent/SCTP]
    $ns multihome-attach-agent $host0_core $sctp0
    $sctp0 set mtu_ 1500
    $sctp0 set dataChunkSize_ 1468
    $sctp0 set numOutStreams_ 1
    $sctp0 set oneHeartbeatTimer_ 0

    if {$quiet == 0} {
	$sctp0 set debugMask_ -1 
	$sctp0 set debugFileIndex_ 0

	set trace_ch [open trace.sctp w]
	$sctp0 set trace_all_ 1
	$sctp0 trace cwnd_
	$sctp0 trace rto_
	$sctp0 trace errorCount_
	$sctp0 attach $trace_ch
    }

    set sctp1 [new Agent/SCTP]
    $ns multihome-attach-agent $host1_core $sctp1
    $sctp1 set mtu_ 1500
    $sctp1 set initialRwnd_ 131072 
    $sctp1 set useDelayedSacks_ 1
    
    if {$quiet == 0} {
	$sctp1 set debugMask_ -1
	$sctp1 set debugFileIndex_ 1
    }

    $ns connect $sctp0 $sctp1

    set ftp0 [new Application/FTP]
    $ftp0 attach-agent $sctp0

    $sctp0 set-primary-destination $host1_if0
}

Test/sctp-multihome2-2AMR-Exceeded instproc run {} {
    $self instvar ns ftp0
    $ns at 0.5 "$ftp0 start"
    $ns at 180.0 "$self finish"
    $ns run
}

Test/sctp-multihome2-2Failover instproc init {} {
    $self instvar ns testName ftp0
    global quiet
    set testName multihome2-2Failover
    $self next

    set host0_core [$ns node]
    set host0_if0 [$ns node]
    set host0_if1 [$ns node]

    $host0_core color Red
    $host0_if0 color Red
    $host0_if1 color Red

    $ns multihome-add-interface $host0_core $host0_if0
    $ns multihome-add-interface $host0_core $host0_if1
    
    set host1_core [$ns node]
    set host1_if0 [$ns node]
    set host1_if1 [$ns node]

    $host1_core color Blue
    $host1_if0 color Blue
    $host1_if1 color Blue

    $ns multihome-add-interface $host1_core $host1_if0
    $ns multihome-add-interface $host1_core $host1_if1
    
    $ns duplex-link $host0_if0 $host1_if0 .5Mb 200ms DropTail
    $ns duplex-link $host0_if1 $host1_if1 .5Mb 200ms DropTail
    
    set err0 [new ErrorModel/List]
    $err0 droplist {15 16 17 18 19 20 21 22 23 24 25 26 27 28 30 31}
    $ns lossmodel $err0 $host0_if0 $host1_if0
    
    set sctp0 [new Agent/SCTP]
    $ns multihome-attach-agent $host0_core $sctp0
    $sctp0 set mtu_ 1500
    $sctp0 set dataChunkSize_ 1468 
    $sctp0 set numOutStreams_ 1

    if {$quiet == 0} {
	$sctp0 set debugMask_ -1 
	$sctp0 set debugFileIndex_ 0

	set trace_ch [open trace.sctp w]
	$sctp0 set trace_all_ 1
	$sctp0 trace cwnd_
	$sctp0 trace rto_
	$sctp0 trace errorCount_
	$sctp0 attach $trace_ch
    }
    
    set sctp1 [new Agent/SCTP]
    $ns multihome-attach-agent $host1_core $sctp1
    $sctp1 set mtu_ 1500
    $sctp1 set initialRwnd_ 131072
    $sctp1 set useDelayedSacks_ 1
    
    if {$quiet == 0} {
	$sctp1 set debugMask_ -1
	$sctp1 set debugFileIndex_ 1
    }
    
    $ns connect $sctp0 $sctp1
    $sctp0 set-primary-destination $host1_if0
    
    set ftp0 [new Application/FTP]
    $ftp0 attach-agent $sctp0
}

Test/sctp-multihome2-2Failover instproc run {} {
    $self instvar ns ftp0
    $ns at 0.5 "$ftp0 start"
    $ns at 180.0 "$self finish"
    $ns run
}

Test/sctp-multihome2-2Failover0 instproc init {} {
    $self instvar ns testName ftp0
    global quiet
    set testName multihome2-2Failover0
    $self next

    set host0_core [$ns node]
    set host0_if0 [$ns node]
    set host0_if1 [$ns node]
    $host0_core color Red
    $host0_if0 color Red
    $host0_if1 color Red
    $ns multihome-add-interface $host0_core $host0_if0
    $ns multihome-add-interface $host0_core $host0_if1

    set host1_core [$ns node]
    set host1_if0 [$ns node]
    set host1_if1 [$ns node]
    $host1_core color Blue
    $host1_if0 color Blue
    $host1_if1 color Blue
    $ns multihome-add-interface $host1_core $host1_if0
    $ns multihome-add-interface $host1_core $host1_if1

    $ns duplex-link $host0_if0 $host1_if0 .5Mb 200ms DropTail
    $ns duplex-link $host0_if1 $host1_if1 .5Mb 200ms DropTail

    set err0 [new ErrorModel/List]
    $err0 droplist {15 16 17 18 19 20 21 22 23 24 25 26 27 28 30 31} 
    $ns lossmodel $err0 $host0_if0 $host1_if0

    set sctp0 [new Agent/SCTP]
    $ns multihome-attach-agent $host0_core $sctp0
    $sctp0 set mtu_ 1500
    $sctp0 set dataChunkSize_ 1468
    $sctp0 set numOutStreams_ 1
    $sctp0 set heartbeatInterval_ 0

    if {$quiet == 0} {
	$sctp0 set debugMask_ -1 
	$sctp0 set debugFileIndex_ 0

	set trace_ch [open trace.sctp w]
	$sctp0 set trace_all_ 1
	$sctp0 trace cwnd_
	$sctp0 trace rto_
	$sctp0 trace errorCount_
	$sctp0 attach $trace_ch
    }

    set sctp1 [new Agent/SCTP]
    $ns multihome-attach-agent $host1_core $sctp1
    $sctp1 set mtu_ 1500
    $sctp1 set initialRwnd_ 131072 
    $sctp1 set useDelayedSacks_ 1
    
    if {$quiet == 0} {
	$sctp1 set debugMask_ -1
	$sctp1 set debugFileIndex_ 1
    }

    $ns connect $sctp0 $sctp1
    $sctp0 set-primary-destination $host1_if0

    set ftp0 [new Application/FTP]
    $ftp0 attach-agent $sctp0
}

Test/sctp-multihome2-2Failover0 instproc run {} {
    $self instvar ns ftp0
    $ns at 0.5 "$ftp0 start"
    $ns at 195.0 "$self finish"
    $ns run
}

Test/sctp-multihome2-2Failover1 instproc init {} {
    $self instvar ns testName ftp0
    global quiet
    set testName multihome2-2Failover1
    $self next

    set host0_core [$ns node]
    set host0_if0 [$ns node]
    set host0_if1 [$ns node]
    $host0_core color Red
    $host0_if0 color Red
    $host0_if1 color Red
    $ns multihome-add-interface $host0_core $host0_if0
    $ns multihome-add-interface $host0_core $host0_if1

    set host1_core [$ns node]
    set host1_if0 [$ns node]
    set host1_if1 [$ns node]
    $host1_core color Blue
    $host1_if0 color Blue
    $host1_if1 color Blue
    $ns multihome-add-interface $host1_core $host1_if0
    $ns multihome-add-interface $host1_core $host1_if1

    $ns duplex-link $host0_if0 $host1_if0 .5Mb 200ms DropTail
    $ns duplex-link $host0_if1 $host1_if1 .5Mb 200ms DropTail

    set err0 [new ErrorModel/List]
    $err0 droplist {15 16 17 18 19 20 21 22 23 24 25 26 27 28 30 31} 
    $ns lossmodel $err0 $host0_if0 $host1_if0

    set sctp0 [new Agent/SCTP]
    $ns multihome-attach-agent $host0_core $sctp0
    $sctp0 set mtu_ 1500
    $sctp0 set dataChunkSize_ 1468
    $sctp0 set numOutStreams_ 1
    $sctp0 set oneHeartbeatTimer_ 1

    if {$quiet == 0} {
	$sctp0 set debugMask_ -1 
	$sctp0 set debugFileIndex_ 0

	set trace_ch [open trace.sctp w]
	$sctp0 set trace_all_ 1
	$sctp0 trace cwnd_
	$sctp0 trace rto_
	$sctp0 trace errorCount_
	$sctp0 attach $trace_ch
    }

    set sctp1 [new Agent/SCTP]
    $ns multihome-attach-agent $host1_core $sctp1
    $sctp1 set mtu_ 1500
    $sctp1 set initialRwnd_ 131072 
    $sctp1 set useDelayedSacks_ 1
    
    if {$quiet == 0} {
	$sctp1 set debugMask_ -1
	$sctp1 set debugFileIndex_ 1
    }

    $ns connect $sctp0 $sctp1
    $sctp0 set-primary-destination $host1_if0

    set ftp0 [new Application/FTP]
    $ftp0 attach-agent $sctp0
}

Test/sctp-multihome2-2Failover1 instproc run {} {
    $self instvar ns ftp0
    $ns at 0.5 "$ftp0 start"
    $ns at 195.0 "$self finish"
    $ns run
}

Test/sctp-multihome2-2Rtx1 instproc init {} {
    $self instvar ns testName ftp0
    global quiet
    set testName multihome2-2Rtx1
    $self next

    set host0_core [$ns node]
    set host0_if0 [$ns node]
    set host0_if1 [$ns node]
    $host0_core color Red
    $host0_if0 color Red
    $host0_if1 color Red
    $ns multihome-add-interface $host0_core $host0_if0
    $ns multihome-add-interface $host0_core $host0_if1
    
    set host1_core [$ns node]
    set host1_if0 [$ns node]
    set host1_if1 [$ns node]
    $host1_core color Blue
    $host1_if0 color Blue
    $host1_if1 color Blue
    $ns multihome-add-interface $host1_core $host1_if0
    $ns multihome-add-interface $host1_core $host1_if1
    
    $ns duplex-link $host0_if0 $host1_if0 .5Mb 200ms DropTail
    $ns duplex-link $host0_if1 $host1_if1 .5Mb 200ms DropTail
    
    set err [new ErrorModel/List]
    $err droplist {15}
    $ns lossmodel $err $host0_if0 $host1_if0
    
    set sctp0 [new Agent/SCTP]
    $ns multihome-attach-agent $host0_core $sctp0
    $sctp0 set mtu_ 1500
    $sctp0 set dataChunkSize_ 1468 
    $sctp0 set numOutStreams_ 1

    if {$quiet == 0} {
	$sctp0 set debugMask_ -1 
	$sctp0 set debugFileIndex_ 0

	set trace_ch [open trace.sctp w]
	$sctp0 set trace_all_ 1
	$sctp0 trace cwnd_
	$sctp0 trace rto_
	$sctp0 trace errorCount_
	$sctp0 attach $trace_ch
    }
    
    set sctp1 [new Agent/SCTP]
    $ns multihome-attach-agent $host1_core $sctp1
    $sctp1 set mtu_ 1500
    $sctp1 set initialRwnd_ 131072
    $sctp1 set useDelayedSacks_ 1
    
    if {$quiet == 0} {
	$sctp1 set debugMask_ -1
	$sctp1 set debugFileIndex_ 1
    }
    
    $ns connect $sctp0 $sctp1
    
    set ftp0 [new Application/FTP]
    $ftp0 attach-agent $sctp0
    
    $sctp0 set-primary-destination $host1_if0
}

Test/sctp-multihome2-2Rtx1 instproc run {} {
    $self instvar ns ftp0
    $ns at 0.5 "$ftp0 start"
    $ns at 10.0 "$self finish"
    $ns run
}

Test/sctp-multihome2-2Rtx3 instproc init {} {
    $self instvar ns testName ftp0
    global quiet
    set testName multihome2-2Rtx3
    $self next

    set host0_core [$ns node]
    set host0_if0 [$ns node]
    set host0_if1 [$ns node]

    $host0_core color Red
    $host0_if0 color Red
    $host0_if1 color Red

    $ns multihome-add-interface $host0_core $host0_if0
    $ns multihome-add-interface $host0_core $host0_if1
    
    set host1_core [$ns node]
    set host1_if0 [$ns node]
    set host1_if1 [$ns node]

    $host1_core color Blue
    $host1_if0 color Blue
    $host1_if1 color Blue

    $ns multihome-add-interface $host1_core $host1_if0
    $ns multihome-add-interface $host1_core $host1_if1

    $ns duplex-link $host0_if0 $host1_if0 .5Mb 200ms DropTail
    $ns duplex-link $host0_if1 $host1_if1 .5Mb 200ms DropTail

    set err [new ErrorModel/List]
    $err droplist {15 16 17}
    $ns lossmodel $err $host0_if0 $host1_if0

    set sctp0 [new Agent/SCTP]
    $ns multihome-attach-agent $host0_core $sctp0
    $sctp0 set mtu_ 1500
    $sctp0 set dataChunkSize_ 1468
    $sctp0 set numOutStreams_ 1

    if {$quiet == 0} {
	$sctp0 set debugMask_ -1 
	$sctp0 set debugFileIndex_ 0

	set trace_ch [open trace.sctp w]
	$sctp0 set trace_all_ 1
	$sctp0 trace cwnd_
	$sctp0 trace rto_
	$sctp0 trace errorCount_
	$sctp0 attach $trace_ch
    }

    set sctp1 [new Agent/SCTP]
    $ns multihome-attach-agent $host1_core $sctp1
    $sctp1 set mtu_ 1500
    $sctp1 set initialRwnd_ 131072 
    $sctp1 set useDelayedSacks_ 1
    
    if {$quiet == 0} {
	$sctp1 set debugMask_ -1
	$sctp1 set debugFileIndex_ 1
    }

    $ns connect $sctp0 $sctp1

    set ftp0 [new Application/FTP]
    $ftp0 attach-agent $sctp0

    $sctp0 set-primary-destination $host1_if0       
}

Test/sctp-multihome2-2Rtx3 instproc run {} {
    $self instvar ns ftp0
    $ns at 0.5 "$ftp0 start"
    $ns at 10.0 "$self finish"
    $ns run
}

Test/sctp-multihome2-2Timeout instproc init {} {
    $self instvar ns testName ftp0
    global quiet
    set testName multihome2-2Timeout
    $self next
    
    set host0_core [$ns node]
    set host0_if0 [$ns node]
    set host0_if1 [$ns node]

    $host0_core color Red
    $host0_if0 color Red
    $host0_if1 color Red

    $ns multihome-add-interface $host0_core $host0_if0
    $ns multihome-add-interface $host0_core $host0_if1
    
    set host1_core [$ns node]
    set host1_if0 [$ns node]
    set host1_if1 [$ns node]

    $host1_core color Blue
    $host1_if0 color Blue
    $host1_if1 color Blue

    $ns multihome-add-interface $host1_core $host1_if0
    $ns multihome-add-interface $host1_core $host1_if1
    
    $ns duplex-link $host0_if0 $host1_if0 .5Mb 200ms DropTail
    $ns duplex-link $host0_if1 $host1_if1 .5Mb 200ms DropTail
    
    set err0 [new ErrorModel/List]
    $err0 droplist {15}
    $ns lossmodel $err0 $host0_if0 $host1_if0
    
    set err1 [new ErrorModel/List]
    $err1 droplist {0}
    $ns lossmodel $err1 $host0_if1 $host1_if1
    
    set sctp0 [new Agent/SCTP]
    $ns multihome-attach-agent $host0_core $sctp0
    $sctp0 set mtu_ 1500
    $sctp0 set dataChunkSize_ 1468 
    $sctp0 set numOutStreams_ 1

    if {$quiet == 0} {
	$sctp0 set debugMask_ -1 
	$sctp0 set debugFileIndex_ 0

	set trace_ch [open trace.sctp w]
	$sctp0 set trace_all_ 1
	$sctp0 trace cwnd_
	$sctp0 trace rto_
	$sctp0 trace errorCount_
	$sctp0 attach $trace_ch
    }
    
    set sctp1 [new Agent/SCTP]
    $ns multihome-attach-agent $host1_core $sctp1
    $sctp1 set mtu_ 1500
    $sctp1 set initialRwnd_ 131072
    $sctp1 set useDelayedSacks_ 1
    
    if {$quiet == 0} {
	$sctp1 set debugMask_ -1
	$sctp1 set debugFileIndex_ 1
    }
    
    $ns connect $sctp0 $sctp1
    $sctp0 set-primary-destination $host1_if0
    
    set ftp0 [new Application/FTP]
    $ftp0 attach-agent $sctp0
}

Test/sctp-multihome2-2Timeout instproc run {} {
    $self instvar ns ftp0
    $ns at 0.5 "$ftp0 start"
    $ns at 12.0 "$self finish"
    $ns run
}

Test/sctp-multihome2-R-2 instproc init {} {
    $self instvar ns testName host1_if1 sctp0 ftp0
    global quiet
    set testName multihome2-R-2
    $self next

    set host0_core [$ns node]
    set host0_if0 [$ns node]
    set host0_if1 [$ns node]
    $host0_core color Red
    $host0_if0 color Red
    $host0_if1 color Red
    $ns multihome-add-interface $host0_core $host0_if0
    $ns multihome-add-interface $host0_core $host0_if1

    set host1_core [$ns node]
    set host1_if0 [$ns node]
    set host1_if1 [$ns node]
    $host1_core color Blue
    $host1_if0 color Blue
    $host1_if1 color Blue
    $ns multihome-add-interface $host1_core $host1_if0
    $ns multihome-add-interface $host1_core $host1_if1

    set router [$ns node]

    $ns duplex-link $host0_if0 $router .5Mb 200ms DropTail
    $ns duplex-link $host0_if1 $router .5Mb 200ms DropTail

    $ns duplex-link $host1_if0 $router .5Mb 200ms DropTail
    $ns duplex-link $host1_if1 $router .5Mb 200ms DropTail

    set sctp0 [new Agent/SCTP]
    $ns multihome-attach-agent $host0_core $sctp0
    $sctp0 set mtu_ 1500
    $sctp0 set dataChunkSize_ 1468
    $sctp0 set numOutStreams_ 1

    if {$quiet == 0} {
	$sctp0 set debugMask_ -1 
	$sctp0 set debugFileIndex_ 0

	set trace_ch [open trace.sctp w]
	$sctp0 set trace_all_ 1
	$sctp0 trace cwnd_
	$sctp0 trace rto_
	$sctp0 trace errorCount_
	$sctp0 attach $trace_ch
    }

    set sctp1 [new Agent/SCTP]
    $ns multihome-attach-agent $host1_core $sctp1
    $sctp1 set mtu_ 1500
    $sctp1 set initialRwnd_ 131072 
    $sctp1 set useDelayedSacks_ 1

    if {$quiet == 0} {
	$sctp1 set debugMask_ -1 
	$sctp1 set debugFileIndex_ 1
    }

    $ns connect $sctp0 $sctp1

    set ftp0 [new Application/FTP]
    $ftp0 attach-agent $sctp0

    $sctp0 set-primary-destination $host1_if0    
}

Test/sctp-multihome2-R-2 instproc run {} {
    $self instvar ns host1_if1 sctp0 ftp0
    $ns at 7.5 "$sctp0 set-primary-destination $host1_if1"
    $ns at 0.5 "$ftp0 start"
    $ns at 12.0 "$self finish"
    $ns run
}

Test/sctp-multihome3-3Timeout instproc init {} {
    $self instvar ns testName ftp0
    global quiet
    set testName multihome3-3Timeout
    $self next
    
    set host0_core [$ns node]
    set host0_if0 [$ns node]
    set host0_if1 [$ns node]
    set host0_if2 [$ns node]
    $host0_core color Red
    $host0_if0 color Red
    $host0_if1 color Red
    $host0_if2 color Red
    $ns multihome-add-interface $host0_core $host0_if0
    $ns multihome-add-interface $host0_core $host0_if1
    $ns multihome-add-interface $host0_core $host0_if2

    set host1_core [$ns node]
    set host1_if0 [$ns node]
    set host1_if1 [$ns node]
    set host1_if2 [$ns node]
    $host1_core color Blue
    $host1_if0 color Blue
    $host1_if1 color Blue
    $host1_if2 color Blue
    $ns multihome-add-interface $host1_core $host1_if0
    $ns multihome-add-interface $host1_core $host1_if1
    $ns multihome-add-interface $host1_core $host1_if2

    $ns duplex-link $host0_if0 $host1_if0 .5Mb 200ms DropTail
    $ns duplex-link $host0_if1 $host1_if1 .5Mb 200ms DropTail
    $ns duplex-link $host0_if2 $host1_if2 .5Mb 200ms DropTail

    set err0 [new ErrorModel/List]
    $err0 droplist {15}
    $ns lossmodel $err0 $host0_if0 $host1_if0

    set err1 [new ErrorModel/List]
    $err1 droplist {0}
    $ns lossmodel $err1 $host0_if1 $host1_if1

    set sctp0 [new Agent/SCTP]
    $ns multihome-attach-agent $host0_core $sctp0
    $sctp0 set mtu_ 1500
    $sctp0 set dataChunkSize_ 1468
    $sctp0 set numOutStreams_ 1
    $sctp0 set oneHeartbeatTimer_ 0

    if {$quiet == 0} {
	$sctp0 set debugMask_ -1 
	$sctp0 set debugFileIndex_ 0

	set trace_ch [open trace.sctp w]
	$sctp0 set trace_all_ 1
	$sctp0 trace cwnd_
	$sctp0 trace rto_
	$sctp0 trace errorCount_
	$sctp0 attach $trace_ch
    }

    set sctp1 [new Agent/SCTP]
    $ns multihome-attach-agent $host1_core $sctp1
    $sctp1 set mtu_ 1500
    $sctp1 set initialRwnd_ 131072 
    $sctp1 set useDelayedSacks_ 1

    if {$quiet == 0} {
	$sctp1 set debugMask_ -1 
	$sctp1 set debugFileIndex_ 1
    }

    $ns connect $sctp0 $sctp1
    $sctp0 set-primary-destination $host1_if0

    set ftp0 [new Application/FTP]
    $ftp0 attach-agent $sctp0
}

Test/sctp-multihome3-3Timeout instproc run {} {
    $self instvar ns ftp0
    $ns at 0.5 "$ftp0 start"
    $ns at 10.0 "$self finish"
    $ns run
}

Test/sctp-multipleDropsSameWnd-1 instproc init {} {
    $self instvar ns testName ftp0
    global quiet
    set testName multipleDropsSameWnd-1
    $self next

    set n0 [$ns node]
    set n1 [$ns node]
    $ns duplex-link $n0 $n1 .5Mb 200ms DropTail
    $ns duplex-link-op $n0 $n1 orient right
    
    set err [new ErrorModel/List]
    $err droplist {12 13 15}
    $ns lossmodel $err $n0 $n1

    set sctp0 [new Agent/SCTP]
    $ns attach-agent $n0 $sctp0
    $sctp0 set mtu_ 1500
    $sctp0 set dataChunkSize_ 1468 
    $sctp0 set numOutStreams_ 1
    
    if {$quiet == 0} {
	$sctp0 set debugMask_ -1 
	$sctp0 set debugFileIndex_ 0

	set trace_ch [open trace.sctp w]
	$sctp0 set trace_all_ 1
	$sctp0 trace cwnd_
	$sctp0 trace rto_
	$sctp0 trace errorCount_
	$sctp0 attach $trace_ch
    }

    set sctp1 [new Agent/SCTP]
    $ns attach-agent $n1 $sctp1
    $sctp1 set mtu_ 1500
    $sctp1 set initialRwnd_ 131072
    $sctp1 set useDelayedSacks_ 0

    if {$quiet == 0} {
	$sctp1 set debugMask_ -1 
	$sctp1 set debugFileIndex_ 1
    }
   
    $ns connect $sctp0 $sctp1
    
    set ftp0 [new Application/FTP]
    $ftp0 attach-agent $sctp0
}

Test/sctp-multipleDropsSameWnd-1 instproc run {} {
    $self instvar ns ftp0
    $ns at 0.5 "$ftp0 start"
    $ns at 7.0 "$self finish"
    
    $ns run
}

Test/sctp-multipleDropsSameWnd-1-delayed instproc init {} {
    $self instvar ns testName ftp0
    global quiet
    set testName multipleDropsSameWnd-1-delayed
    $self next

    set n0 [$ns node]
    set n1 [$ns node]
    $ns duplex-link $n0 $n1 .5Mb 200ms DropTail
    $ns duplex-link-op $n0 $n1 orient right
    
    set err [new ErrorModel/List]
    $err droplist {12 13 15}
    $ns lossmodel $err $n0 $n1
    
    set sctp0 [new Agent/SCTP]
    $ns attach-agent $n0 $sctp0
    $sctp0 set mtu_ 1500
    $sctp0 set dataChunkSize_ 1468 
    $sctp0 set numOutStreams_ 1
    
    if {$quiet == 0} {
	$sctp0 set debugMask_ -1 
	$sctp0 set debugFileIndex_ 0

	set trace_ch [open trace.sctp w]
	$sctp0 set trace_all_ 1
	$sctp0 trace cwnd_
	$sctp0 trace rto_
	$sctp0 trace errorCount_
	$sctp0 attach $trace_ch
    }
   
    set sctp1 [new Agent/SCTP]
    $ns attach-agent $n1 $sctp1
    $sctp1 set mtu_ 1500
    $sctp1 set initialRwnd_ 131072
    $sctp1 set useDelayedSacks_ 1
    
    if {$quiet == 0} {
	$sctp1 set debugMask_ -1 
	$sctp1 set debugFileIndex_ 1
    }
   
    $ns connect $sctp0 $sctp1
    
    set ftp0 [new Application/FTP]
    $ftp0 attach-agent $sctp0
}

Test/sctp-multipleDropsSameWnd-1-delayed instproc run {} {
    $self instvar ns ftp0
    $ns at 0.5 "$ftp0 start"
    $ns at 7.0 "$self finish"
    
    $ns run
}

Test/sctp-multipleDropsSameWnd-2 instproc init {} {
    $self instvar ns testName ftp0
    global quiet
    set testName multipleDropsSameWnd-2
    $self next

    set n0 [$ns node]
    set n1 [$ns node]
    $ns duplex-link $n0 $n1 .5Mb 200ms DropTail
    $ns duplex-link-op $n0 $n1 orient right
    
    set err [new ErrorModel/List]
    $err droplist {12 13 14 15}
    $ns lossmodel $err $n0 $n1
    
    set sctp0 [new Agent/SCTP]
    $ns attach-agent $n0 $sctp0
    $sctp0 set mtu_ 1500
    $sctp0 set dataChunkSize_ 1468 
    $sctp0 set numOutStreams_ 1
    
    if {$quiet == 0} {
	$sctp0 set debugMask_ -1 
	$sctp0 set debugFileIndex_ 0

	set trace_ch [open trace.sctp w]
	$sctp0 set trace_all_ 1
	$sctp0 trace cwnd_
	$sctp0 trace rto_
	$sctp0 trace errorCount_
	$sctp0 attach $trace_ch
    }
   
    set sctp1 [new Agent/SCTP]
    $ns attach-agent $n1 $sctp1
    $sctp1 set mtu_ 1500
    $sctp1 set initialRwnd_ 131072
    $sctp1 set useDelayedSacks_ 0
    
    if {$quiet == 0} {
	$sctp1 set debugMask_ -1 
	$sctp1 set debugFileIndex_ 1
    }
   
    $ns connect $sctp0 $sctp1
    
    set ftp0 [new Application/FTP]
    $ftp0 attach-agent $sctp0
}

Test/sctp-multipleDropsSameWnd-2 instproc run {} {
    $self instvar ns ftp0
    $ns at 0.5 "$ftp0 start"
    $ns at 7.0 "$self finish"
    
    $ns run
}

Test/sctp-multipleDropsSameWnd-3 instproc init {} {
    $self instvar ns testName ftp0
    global quiet
    set testName multipleDropsSameWnd-3
    $self next

    set n0 [$ns node]
    set n1 [$ns node]
    $ns duplex-link $n0 $n1 .5Mb 200ms DropTail
    $ns duplex-link-op $n0 $n1 orient right
    
    set err [new ErrorModel/List]
    $err droplist {11 12 14 15}
    $ns lossmodel $err $n0 $n1
    
    set sctp0 [new Agent/SCTP]
    $ns attach-agent $n0 $sctp0
    $sctp0 set mtu_ 1500
    $sctp0 set dataChunkSize_ 1468 
    $sctp0 set numOutStreams_ 1
    
    if {$quiet == 0} {
	$sctp0 set debugMask_ -1 
	$sctp0 set debugFileIndex_ 0

	set trace_ch [open trace.sctp w]
	$sctp0 set trace_all_ 1
	$sctp0 trace cwnd_
	$sctp0 trace rto_
	$sctp0 trace errorCount_
	$sctp0 attach $trace_ch
    }
   
    set sctp1 [new Agent/SCTP]
    $ns attach-agent $n1 $sctp1
    $sctp1 set mtu_ 1500
    $sctp1 set initialRwnd_ 131072
    $sctp1 set useDelayedSacks_ 0
    
    if {$quiet == 0} {
	$sctp1 set debugMask_ -1 
	$sctp1 set debugFileIndex_ 1
    }
   
    $ns connect $sctp0 $sctp1
    
    set ftp0 [new Application/FTP]
    $ftp0 attach-agent $sctp0
}

Test/sctp-multipleDropsSameWnd-3 instproc run {} {
    $self instvar ns ftp0
    $ns at 0.5 "$ftp0 start"
    $ns at 7.0 "$self finish"
    
    $ns run
}

Test/sctp-multipleDropsTwoWnds-1-delayed instproc init {} {
    $self instvar ns testName ftp0
    global quiet
    set testName multipleDropsTwoWnds-1-delayed
    $self next

    set n0 [$ns node]
    set n1 [$ns node]
    $ns duplex-link $n0 $n1 .5Mb 200ms DropTail
    $ns duplex-link-op $n0 $n1 orient right
    
    set err [new ErrorModel/List]
    $err droplist {14 15 16 17}
    $ns lossmodel $err $n0 $n1
    
    set sctp0 [new Agent/SCTP]
    $ns attach-agent $n0 $sctp0
    $sctp0 set mtu_ 1500
    $sctp0 set dataChunkSize_ 1468 
    $sctp0 set numOutStreams_ 1
    
    if {$quiet == 0} {
	$sctp0 set debugMask_ -1 
	$sctp0 set debugFileIndex_ 0

	set trace_ch [open trace.sctp w]
	$sctp0 set trace_all_ 1
	$sctp0 trace cwnd_
	$sctp0 trace rto_
	$sctp0 trace errorCount_
	$sctp0 attach $trace_ch
    }
   
    set sctp1 [new Agent/SCTP]
    $ns attach-agent $n1 $sctp1
    $sctp1 set mtu_ 1500
    $sctp1 set initialRwnd_ 131072
    $sctp1 set useDelayedSacks_ 1
    
    if {$quiet == 0} {
	$sctp1 set debugMask_ -1 
	$sctp1 set debugFileIndex_ 1
    }
   
    $ns connect $sctp0 $sctp1
    
    set ftp0 [new Application/FTP]
    $ftp0 attach-agent $sctp0
}

Test/sctp-multipleDropsTwoWnds-1-delayed instproc run {} {
    $self instvar ns ftp0
    $ns at 0.5 "$ftp0 start"
    $ns at 10.0 "$self finish"
    $ns run
}

Test/sctp-multipleRtx instproc init {} {
    $self instvar ns testName ftp0
    global quiet
    set testName multipleRtx
    $self next

    set n0 [$ns node]
    set n1 [$ns node]
    $ns duplex-link $n0 $n1 .5Mb 300ms DropTail
    $ns duplex-link-op $n0 $n1 orient right
    $ns queue-limit $n0 $n1 10000
    
    set err [new ErrorModel/List]
    $err droplist {16 35}
    $ns lossmodel $err $n0 $n1
    
    set sctp0 [new Agent/SCTP]
    $ns attach-agent $n0 $sctp0
    $sctp0 set mtu_ 1500
    $sctp0 set dataChunkSize_ 1468 
    $sctp0 set numOutStreams_ 1
    
    if {$quiet == 0} {
	$sctp0 set debugMask_ -1 
	$sctp0 set debugFileIndex_ 0

	set trace_ch [open trace.sctp w]
	$sctp0 set trace_all_ 1
	$sctp0 trace cwnd_
	$sctp0 trace rto_
	$sctp0 trace errorCount_
	$sctp0 attach $trace_ch
    }
   
    set sctp1 [new Agent/SCTP]
    $ns attach-agent $n1 $sctp1
    $sctp1 set mtu_ 1500
    $sctp1 set initialRwnd_ 131072
    $sctp1 set useDelayedSacks_ 0
    
    if {$quiet == 0} {
	$sctp1 set debugMask_ -1 
	$sctp1 set debugFileIndex_ 1
    }
   
    $ns connect $sctp0 $sctp1
    
    set ftp0 [new Application/FTP]
    $ftp0 attach-agent $sctp0
}

Test/sctp-multipleRtx instproc run {} {
    $self instvar ns ftp0
    $ns at 0.5 "$ftp0 start"
    $ns at 10.0 "$self finish"
    $ns run
}

Test/sctp-multipleRtx-early instproc init {} {
    $self instvar ns testName ftp0
    global quiet
    set testName multipleRtx-early
    $self next

    set n0 [$ns node]
    set n1 [$ns node]
    $ns duplex-link $n0 $n1 .5Mb 300ms DropTail
    $ns duplex-link-op $n0 $n1 orient right
    $ns queue-limit $n0 $n1 10000
    
    set err [new ErrorModel/List]
    $err droplist {4 11}
    $ns lossmodel $err $n0 $n1
    
    set sctp0 [new Agent/SCTP]
    $ns attach-agent $n0 $sctp0
    $sctp0 set mtu_ 1500
    $sctp0 set dataChunkSize_ 1468
    $sctp0 set numOutStreams_ 1
    
    if {$quiet == 0} {
	$sctp0 set debugMask_ -1 
	$sctp0 set debugFileIndex_ 0

	set trace_ch [open trace.sctp w]
	$sctp0 set trace_all_ 1
	$sctp0 trace cwnd_
	$sctp0 trace rto_
	$sctp0 trace errorCount_
	$sctp0 attach $trace_ch
    }

    set sctp1 [new Agent/SCTP]
    $ns attach-agent $n1 $sctp1
    $sctp1 set mtu_ 1500
    $sctp1 set initialRwnd_ 131072
    $sctp1 set useDelayedSacks_ 0
   
    if {$quiet == 0} {
	$sctp1 set debugMask_ -1 
	$sctp1 set debugFileIndex_ 1
    }
   
    $ns connect $sctp0 $sctp1
    
    set ftp0 [new Application/FTP]
    $ftp0 attach-agent $sctp0
}

Test/sctp-multipleRtx-early instproc run {} {
    $self instvar ns ftp0
    $ns at 0.5 "$ftp0 start"
    $ns at 10.0 "$self finish"
    $ns run
}

Test/sctp-noEarlyHBs instproc init {} {
    $self instvar ns testName ftp0
    global quiet
    set testName noEarlyHBs
    $self next

    set n0 [$ns node]
    set n1 [$ns node]
    $ns duplex-link $n0 $n1 .5Mb 200ms DropTail
    $ns duplex-link-op $n0 $n1 orient right
    
    set sctp0 [new Agent/SCTP]
    $ns attach-agent $n0 $sctp0
    $sctp0 set mtu_ 1500
    $sctp0 set dataChunkSize_ 1468
    $sctp0 set numOutStreams_ 1
   
    if {$quiet == 0} {
	$sctp0 set debugMask_ -1 
	$sctp0 set debugFileIndex_ 0

	set trace_ch [open trace.sctp w]
	$sctp0 set trace_all_ 1
	$sctp0 trace cwnd_
	$sctp0 trace rto_
	$sctp0 trace errorCount_
	$sctp0 attach $trace_ch
    }
    
    set sctp1 [new Agent/SCTP]
    $ns attach-agent $n1 $sctp1
    $sctp1 set mtu_ 1500
    $sctp1 set initialRwnd_ 131072
    $sctp1 set useDelayedSacks_ 0
   
    if {$quiet == 0} {
	$sctp1 set debugMask_ -1 
	$sctp1 set debugFileIndex_ 1
    }
    
    $ns connect $sctp0 $sctp1
    
    set ftp0 [new Application/FTP]
    $ftp0 attach-agent $sctp0
}

Test/sctp-noEarlyHBs instproc run {} {
    $self instvar ns ftp0
    $ns at 50.0 "$ftp0 start"
    $ns at 55.0 "$self finish"
    $ns run
}

Test/sctp-smallRwnd instproc init {} {
    $self instvar ns testName ftp0
    global quiet
    set testName smallRwnd
    $self next

    set n0 [$ns node]
    set n1 [$ns node]
    $ns duplex-link $n0 $n1 .5Mb 300ms DropTail
    $ns duplex-link-op $n0 $n1 orient right
    $ns queue-limit $n0 $n1 10000
    
    set err [new ErrorModel/List]
    
    set sctp0 [new Agent/SCTP]
    $ns attach-agent $n0 $sctp0
    $sctp0 set mtu_ 1500
    $sctp0 set dataChunkSize_ 724
    $sctp0 set numOutStreams_ 1
   
    if {$quiet == 0} {
	$sctp0 set debugMask_ -1 
	$sctp0 set debugFileIndex_ 0

	set trace_ch [open trace.sctp w]
	$sctp0 set trace_all_ 1
	$sctp0 trace cwnd_
	$sctp0 trace rto_
	$sctp0 trace errorCount_
	$sctp0 attach $trace_ch
    }
    
    set sctp1 [new Agent/SCTP]
    $ns attach-agent $n1 $sctp1
    $sctp1 set mtu_ 1500
    $sctp1 set initialRwnd_ 4096
    $sctp1 set useDelayedSacks_ 0
   
    if {$quiet == 0} {
	$sctp1 set debugMask_ -1 
	$sctp1 set debugFileIndex_ 1
    }
    
    $ns connect $sctp0 $sctp1
    
    set ftp0 [new Application/FTP]
    $ftp0 attach-agent $sctp0
}

Test/sctp-smallRwnd instproc run {} {
    $self instvar ns ftp0
    $ns at 0.5 "$ftp0 start"
    $ns at 10.0 "$self finish"
    $ns run
}

Test/sctp-zeroRtx instproc init {} {
    $self instvar ns testName ftp0
    global quiet
    set testName zeroRtx 
    $self next

    set n0 [$ns node]
    set n1 [$ns node]
    $ns duplex-link $n0 $n1 .5Mb 200ms DropTail
    $ns duplex-link-op $n0 $n1 orient right
    
    set err [new ErrorModel/List]
    $err droplist {30}
        
    $ns lossmodel $err $n0 $n1
    
    set sctp0 [new Agent/SCTP]
    $ns attach-agent $n0 $sctp0
    $sctp0 set mtu_ 1500
    $sctp0 set dataChunkSize_ 1468
    $sctp0 set numOutStreams_ 1
    $sctp0 set numUnrelStreams_ 1
   
    if {$quiet == 0} {
	$sctp0 set debugMask_ -1 
	$sctp0 set debugFileIndex_ 0

	set trace_ch [open trace.sctp w]
	$sctp0 set trace_all_ 1
	$sctp0 trace cwnd_
	$sctp0 trace rto_
	$sctp0 trace errorCount_
	$sctp0 attach $trace_ch
    }

    set sctp1 [new Agent/SCTP]
    $ns attach-agent $n1 $sctp1
    $sctp1 set mtu_ 1500
    $sctp1 set initialRwnd_ 131072
    $sctp1 set useDelayedSacks_ 1
   
    if {$quiet == 0} {
	$sctp1 set debugMask_ -1 
	$sctp1 set debugFileIndex_ 1
    }
    
    $ns connect $sctp0 $sctp1
    
    set ftp0 [new Application/FTP]
    $ftp0 attach-agent $sctp0
}

Test/sctp-zeroRtx instproc run {} {
    $self instvar ns ftp0
    $ns at 0.5 "$ftp0 start"
    $ns at 6.0 "$self finish"
    $ns run
}

Test/sctp-zeroRtx-burstLoss instproc init {} {
    $self instvar ns testName ftp0
    global quiet
    set testName zeroRtx-burstLoss
    $self next

    set n0 [$ns node]
    set n1 [$ns node]
    $ns duplex-link $n0 $n1 .5Mb 200ms DropTail
    $ns duplex-link-op $n0 $n1 orient right
    
    set err [new ErrorModel/List]
    $err droplist {16 17 18 19 20}
    $ns lossmodel $err $n0 $n1

    set sctp0 [new Agent/SCTP]
    $ns attach-agent $n0 $sctp0
    $sctp0 set mtu_ 1500
    $sctp0 set dataChunkSize_ 1468
    $sctp0 set numOutStreams_ 1
    $sctp0 set numUnrelStreams_ 1
   
    if {$quiet == 0} {
	$sctp0 set debugMask_ -1 
	$sctp0 set debugFileIndex_ 0

	set trace_ch [open trace.sctp w]
	$sctp0 set trace_all_ 1
	$sctp0 trace cwnd_
	$sctp0 trace rto_
	$sctp0 trace errorCount_
	$sctp0 attach $trace_ch
    }
    
    set sctp1 [new Agent/SCTP]
    $ns attach-agent $n1 $sctp1
    $sctp1 set mtu_ 1500
    $sctp1 set initialRwnd_ 131072
    $sctp1 set useDelayedSacks_ 0
   
    if {$quiet == 0} {
	$sctp1 set debugMask_ -1 
	$sctp1 set debugFileIndex_ 1
    }
    
    $ns connect $sctp0 $sctp1
    
    set ftp0 [new Application/FTP]
    $ftp0 attach-agent $sctp0
}

Test/sctp-zeroRtx-burstLoss instproc run {} {
    $self instvar ns ftp0
    $ns at 0.5 "$ftp0 start"
    $ns at 5.0 "$self finish"
    $ns run
}

Test/sctp-hbAfterRto-2packetsTimeout instproc init {} {
    $self instvar ns testName ftp0
    global quiet
    set testName hbAfterRto-2packetsTimeout
    $self next

    set n0 [$ns node]
    set n1 [$ns node]
    $ns duplex-link $n0 $n1 .5Mb 200ms DropTail
    $ns duplex-link-op $n0 $n1 orient right

    set err [new ErrorModel/List]
    $err droplist {14 15 31 32}
    $ns lossmodel $err $n0 $n1

    set sctp0 [new Agent/SCTP/HbAfterRto]
    $ns attach-agent $n0 $sctp0
    $sctp0 set mtu_ 1500
    $sctp0 set dataChunkSize_ 1468
    $sctp0 set numOutStreams_ 1
   
    if {$quiet == 0} {
	$sctp0 set debugMask_ -1 
	$sctp0 set debugFileIndex_ 0

	set trace_ch [open trace.sctp w]
	$sctp0 set trace_all_ 1
	$sctp0 trace cwnd_
	$sctp0 trace rto_
	$sctp0 trace errorCount_
	$sctp0 attach $trace_ch
    }
    
    set sctp1 [new Agent/SCTP/HbAfterRto]
    $ns attach-agent $n1 $sctp1
    $sctp1 set mtu_ 1500
    $sctp1 set initialRwnd_ 131072
    $sctp1 set useDelayedSacks_ 0
   
    if {$quiet == 0} {
	$sctp1 set debugMask_ -1 
	$sctp1 set debugFileIndex_ 1
    }
    
    $ns connect $sctp0 $sctp1
    
    set ftp0 [new Application/FTP]
    $ftp0 attach-agent $sctp0
}

Test/sctp-hbAfterRto-2packetsTimeout instproc run {} {
    $self instvar ns ftp0
    $ns at 0.5 "$ftp0 start"
    $ns at 4.5 "$ftp0 stop"
    $ns at 10.0 "$self finish"
    $ns run
}

Test/sctp-hbAfterRto-multihome2-2Timeout instproc init {} {
    $self instvar ns testName ftp0
    global quiet
    set testName hbAfterRto-multihome2-2Timeout
    $self next

    set host0_core [$ns node]
    set host0_if0 [$ns node]
    set host0_if1 [$ns node]
    $host0_core color Red
    $host0_if0 color Red
    $host0_if1 color Red
    $ns multihome-add-interface $host0_core $host0_if0
    $ns multihome-add-interface $host0_core $host0_if1

    set host1_core [$ns node]
    set host1_if0 [$ns node]
    set host1_if1 [$ns node]
    $host1_core color Blue
    $host1_if0 color Blue
    $host1_if1 color Blue
    $ns multihome-add-interface $host1_core $host1_if0
    $ns multihome-add-interface $host1_core $host1_if1

    $ns duplex-link $host0_if0 $host1_if0 .5Mb 200ms DropTail
    $ns duplex-link $host0_if1 $host1_if1 .5Mb 200ms DropTail

    set err0 [new ErrorModel/List]
    $err0 droplist {15}
    $ns lossmodel $err0 $host0_if0 $host1_if0

    set err1 [new ErrorModel/List]
    $err1 droplist {0}
    $ns lossmodel $err1 $host0_if1 $host1_if1

    set sctp0 [new Agent/SCTP/HbAfterRto]
    $ns multihome-attach-agent $host0_core $sctp0
    $sctp0 set mtu_ 1500
    $sctp0 set dataChunkSize_ 1468
    $sctp0 set numOutStreams_ 1

    if {$quiet == 0} {
	$sctp0 set debugMask_ -1 
	$sctp0 set debugFileIndex_ 0

	set trace_ch [open trace.sctp w]
	$sctp0 set trace_all_ 1
	$sctp0 trace cwnd_
	$sctp0 trace rto_
	$sctp0 trace errorCount_
	$sctp0 attach $trace_ch
    }
    
    set sctp1 [new Agent/SCTP/HbAfterRto]
    $ns multihome-attach-agent $host1_core $sctp1
    $sctp1 set mtu_ 1500
    $sctp1 set initialRwnd_ 131072 
    $sctp1 set useDelayedSacks_ 1
   
    if {$quiet == 0} {
	$sctp1 set debugMask_ -1 
	$sctp1 set debugFileIndex_ 1
    }
    
    $ns connect $sctp0 $sctp1
    $sctp0 set-primary-destination $host1_if0
    
    set ftp0 [new Application/FTP]
    $ftp0 attach-agent $sctp0
}

Test/sctp-hbAfterRto-multihome2-2Timeout instproc run {} {
    $self instvar ns ftp0
    $ns at 0.5 "$ftp0 start"
    $ns at 9.0 "$ftp0 stop"
    $ns at 12.0 "$self finish"
    $ns run
}

Test/sctp-multipleFastRtx-2packetsTimeout instproc init {} {
    $self instvar ns testName ftp0
    global quiet
    set testName multipleFastRtx-2packetsTimeout
    $self next

    set n0 [$ns node]
    set n1 [$ns node]
    $ns duplex-link $n0 $n1 .5Mb 200ms DropTail
    $ns duplex-link-op $n0 $n1 orient right

    set err [new ErrorModel/List]
    $err droplist {14 15 31 32}
    $ns lossmodel $err $n0 $n1

    set sctp0 [new Agent/SCTP/MultipleFastRtx]
    $ns attach-agent $n0 $sctp0
    $sctp0 set mtu_ 1500
    $sctp0 set dataChunkSize_ 1468
    $sctp0 set numOutStreams_ 1
   
    if {$quiet == 0} {
	$sctp0 set debugMask_ -1 
	$sctp0 set debugFileIndex_ 0

	set trace_ch [open trace.sctp w]
	$sctp0 set trace_all_ 1
	$sctp0 trace cwnd_
	$sctp0 trace rto_
	$sctp0 trace errorCount_
	$sctp0 attach $trace_ch
    }
    
    set sctp1 [new Agent/SCTP/MultipleFastRtx]
    $ns attach-agent $n1 $sctp1
    $sctp1 set mtu_ 1500
    $sctp1 set initialRwnd_ 131072
    $sctp1 set useDelayedSacks_ 0
   
    if {$quiet == 0} {
	$sctp1 set debugMask_ -1 
	$sctp1 set debugFileIndex_ 1
    }
    
    $ns connect $sctp0 $sctp1
    
    set ftp0 [new Application/FTP]
    $ftp0 attach-agent $sctp0
}

Test/sctp-multipleFastRtx-2packetsTimeout instproc run {} {
    $self instvar ns ftp0
    $ns at 0.5 "$ftp0 start"
    $ns at 4.5 "$ftp0 stop"
    $ns at 10.0 "$self finish"
    $ns run
}

Test/sctp-multipleFastRtx-multihome2-2Timeout instproc init {} {
    $self instvar ns testName ftp0
    global quiet
    set testName multipleFastRtx-multihome2-2Timeout
    $self next

    set host0_core [$ns node]
    set host0_if0 [$ns node]
    set host0_if1 [$ns node]
    $host0_core color Red
    $host0_if0 color Red
    $host0_if1 color Red
    $ns multihome-add-interface $host0_core $host0_if0
    $ns multihome-add-interface $host0_core $host0_if1

    set host1_core [$ns node]
    set host1_if0 [$ns node]
    set host1_if1 [$ns node]
    $host1_core color Blue
    $host1_if0 color Blue
    $host1_if1 color Blue
    $ns multihome-add-interface $host1_core $host1_if0
    $ns multihome-add-interface $host1_core $host1_if1

    $ns duplex-link $host0_if0 $host1_if0 .5Mb 200ms DropTail
    $ns duplex-link $host0_if1 $host1_if1 .5Mb 200ms DropTail

    set err0 [new ErrorModel/List]
    $err0 droplist {15}
    $ns lossmodel $err0 $host0_if0 $host1_if0

    set err1 [new ErrorModel/List]
    $err1 droplist {0}
    $ns lossmodel $err1 $host0_if1 $host1_if1

    set sctp0 [new Agent/SCTP/MultipleFastRtx]
    $ns multihome-attach-agent $host0_core $sctp0
    $sctp0 set mtu_ 1500
    $sctp0 set dataChunkSize_ 1468
    $sctp0 set numOutStreams_ 1

    if {$quiet == 0} {
	$sctp0 set debugMask_ -1 
	$sctp0 set debugFileIndex_ 0

	set trace_ch [open trace.sctp w]
	$sctp0 set trace_all_ 1
	$sctp0 trace cwnd_
	$sctp0 trace rto_
	$sctp0 trace errorCount_
	$sctp0 attach $trace_ch
    }
    
    set sctp1 [new Agent/SCTP/MultipleFastRtx]
    $ns multihome-attach-agent $host1_core $sctp1
    $sctp1 set mtu_ 1500
    $sctp1 set initialRwnd_ 131072 
    $sctp1 set useDelayedSacks_ 1
   
    if {$quiet == 0} {
	$sctp1 set debugMask_ -1 
	$sctp1 set debugFileIndex_ 1
    }
    
    $ns connect $sctp0 $sctp1
    $sctp0 set-primary-destination $host1_if0
    
    set ftp0 [new Application/FTP]
    $ftp0 attach-agent $sctp0
}

Test/sctp-multipleFastRtx-multihome2-2Timeout instproc run {} {
    $self instvar ns ftp0
    $ns at 0.5 "$ftp0 start"
    $ns at 9.0 "$ftp0 stop"
    $ns at 12.0 "$self finish"
    $ns run
}

Test/sctp-newReno instproc init {} {
    $self instvar ns testName ftp0
    global quiet
    set testName newReno
    $self next

    set n0 [$ns node]
    set n1 [$ns node]
    $ns duplex-link $n0 $n1 .5Mb 200ms DropTail
    $ns duplex-link-op $n0 $n1 orient right

    set err [new ErrorModel/List]
    $err droplist {16 28 30}
    $ns lossmodel $err $n0 $n1

    set sctp0 [new Agent/SCTP/Newreno]
    $ns attach-agent $n0 $sctp0
    $sctp0 set mtu_ 1500
    $sctp0 set dataChunkSize_ 1468
    $sctp0 set numOutStreams_ 1
    $sctp0 set initialCwnd_ 1

    if {$quiet == 0} {
	$sctp0 set debugMask_ -1 
	$sctp0 set debugFileIndex_ 0

	set trace_ch [open trace.sctp w]
	$sctp0 set trace_all_ 1
	$sctp0 trace cwnd_
	$sctp0 trace rto_
	$sctp0 trace errorCount_
	$sctp0 attach $trace_ch
    }
    
    set sctp1 [new Agent/SCTP/Newreno]
    $ns attach-agent $n1 $sctp1
    $sctp1 set mtu_ 1500
    $sctp1 set initialRwnd_ 131072
    $sctp1 set useDelayedSacks_ 0
   
    if {$quiet == 0} {
	$sctp1 set debugMask_ -1 
	$sctp1 set debugFileIndex_ 1
    }
    
    $ns connect $sctp0 $sctp1
    
    set ftp0 [new Application/FTP]
    $ftp0 attach-agent $sctp0
}

Test/sctp-newReno instproc run {} {
    $self instvar ns ftp0
    $ns at 0.5 "$ftp0 start"
    $ns at 7.0 "$ftp0 stop"
    $ns at 10.0 "$self finish"
    $ns run
}

Test/sctp-timestamp-multihome2-2Rtx3 instproc init {} {
    $self instvar ns testName ftp0
    global quiet
    set testName timestamp-multihome2-2Rt3
    $self next

    set host0_core [$ns node]
    set host0_if0 [$ns node]
    set host0_if1 [$ns node]
    $host0_core color Red
    $host0_if0 color Red
    $host0_if1 color Red
    $ns multihome-add-interface $host0_core $host0_if0
    $ns multihome-add-interface $host0_core $host0_if1

    set host1_core [$ns node]
    set host1_if0 [$ns node]
    set host1_if1 [$ns node]
    $host1_core color Blue
    $host1_if0 color Blue
    $host1_if1 color Blue
    $ns multihome-add-interface $host1_core $host1_if0
    $ns multihome-add-interface $host1_core $host1_if1

    $ns duplex-link $host0_if0 $host1_if0 .5Mb 200ms DropTail
    $ns duplex-link $host0_if1 $host1_if1 .5Mb 200ms DropTail

    set err [new ErrorModel/List]
    $err droplist {15 16 17}
    $ns lossmodel $err $host0_if0 $host1_if0

    set sctp0 [new Agent/SCTP/Timestamp]
    $ns multihome-attach-agent $host0_core $sctp0
    $sctp0 set mtu_ 1500
    $sctp0 set dataChunkSize_ 1456  # sctp/ip = 32, timestamp = 12
    $sctp0 set numOutStreams_ 1

    if {$quiet == 0} {
	$sctp0 set debugMask_ -1 
	$sctp0 set debugFileIndex_ 0

	set trace_ch [open trace.sctp w]
	$sctp0 set trace_all_ 1
	$sctp0 trace cwnd_
	$sctp0 trace rto_
	$sctp0 trace errorCount_
	$sctp0 attach $trace_ch
    }
    
    set sctp1 [new Agent/SCTP/Timestamp]
    $ns multihome-attach-agent $host1_core $sctp1
    $sctp1 set mtu_ 1500
    $sctp1 set dataChunkSize_ 512
    $sctp1 set initialRwnd_ 131072 
    $sctp1 set useDelayedSacks_ 1
   
    if {$quiet == 0} {
	$sctp1 set debugMask_ -1 
	$sctp1 set debugFileIndex_ 1
    }
    
    $ns connect $sctp0 $sctp1
    $sctp0 set-primary-destination $host1_if0
    
    set ftp0 [new Application/FTP]
    $ftp0 attach-agent $sctp0
}

Test/sctp-timestamp-multihome2-2Rtx3 instproc run {} {
    $self instvar ns ftp0
    $ns at 0.5 "$ftp0 start"
    $ns at 4.5 "$ftp0 stop"
    $ns at 10.0 "$self finish"
    $ns run
}

Test/sctp-timestamp-multihome2-2Timeout instproc init {} {
    $self instvar ns testName ftp0
    global quiet
    set testName timestamp-multihome2-2Timeout
    $self next

    set host0_core [$ns node]
    set host0_if0 [$ns node]
    set host0_if1 [$ns node]
    $host0_core color Red
    $host0_if0 color Red
    $host0_if1 color Red
    $ns multihome-add-interface $host0_core $host0_if0
    $ns multihome-add-interface $host0_core $host0_if1

    set host1_core [$ns node]
    set host1_if0 [$ns node]
    set host1_if1 [$ns node]
    $host1_core color Blue
    $host1_if0 color Blue
    $host1_if1 color Blue
    $ns multihome-add-interface $host1_core $host1_if0
    $ns multihome-add-interface $host1_core $host1_if1

    $ns duplex-link $host0_if0 $host1_if0 .5Mb 200ms DropTail
    $ns duplex-link $host0_if1 $host1_if1 .5Mb 200ms DropTail

    set err0 [new ErrorModel/List]
    $err0 droplist {15}
    $ns lossmodel $err0 $host0_if0 $host1_if0

    set err1 [new ErrorModel/List]
    $err1 droplist {0}
    $ns lossmodel $err1 $host0_if1 $host1_if1

    set sctp0 [new Agent/SCTP/Timestamp]
    $ns multihome-attach-agent $host0_core $sctp0
    $sctp0 set mtu_ 1500
    $sctp0 set dataChunkSize_ 1456  # sctp/ip = 32, timestamp = 12
    $sctp0 set numOutStreams_ 1

    if {$quiet == 0} {
	$sctp0 set debugMask_ -1 
	$sctp0 set debugFileIndex_ 0

	set trace_ch [open trace.sctp w]
	$sctp0 set trace_all_ 1
	$sctp0 trace cwnd_
	$sctp0 trace rto_
	$sctp0 trace errorCount_
	$sctp0 attach $trace_ch
    }
    
    set sctp1 [new Agent/SCTP/Timestamp]
    $ns multihome-attach-agent $host1_core $sctp1
    $sctp1 set mtu_ 1500
    $sctp1 set dataChunkSize_ 512
    $sctp1 set initialRwnd_ 131072 
    $sctp1 set useDelayedSacks_ 1
   
    if {$quiet == 0} {
	$sctp1 set debugMask_ -1 
	$sctp1 set debugFileIndex_ 1
    }
    
    $ns connect $sctp0 $sctp1
    $sctp0 set-primary-destination $host1_if0
    
    set ftp0 [new Application/FTP]
    $ftp0 attach-agent $sctp0
}

Test/sctp-timestamp-multihome2-2Timeout instproc run {} {
    $self instvar ns ftp0
    $ns at 0.5 "$ftp0 start"
    $ns at 9.0 "$ftp0 stop"
    $ns at 12.0 "$self finish"
    $ns run
}

proc runtest {arg} {
    global quiet
    set quiet 0
    
    set b [llength $arg]
    if {$b == 1} {
	set test $arg
    } elseif {$b == 2} {
	set test [lindex $arg 0]
	set q [lindex $arg 1]
	if { $q == "QUIET" } {
	    set quiet 1
	} else { usage }
    } else { usage }
    
    switch $test {
	sctp-2packetsTimeout -
	sctp-AMR-Exceeded -
	sctp-Rel1-Loss2  -
	sctp-burstAfterFastRtxRecovery  -
	sctp-burstAfterFastRtxRecovery-2  -
	sctp-cwndFreeze  -
	sctp-cwndFreeze-multistream  -
	sctp-hugeRwnd  -
	sctp-initRtx  -
	sctp-multihome1-2  -
	sctp-multihome2-1 -
	sctp-multihome2-2AMR-Exceeded -
	sctp-multihome2-2Failover  -
	sctp-multihome2-2Failover0 -
	sctp-multihome2-2Failover1 -
	sctp-multihome2-2Rtx1   -
	sctp-multihome2-2Rtx3  -
	sctp-multihome2-2Timeout -
	sctp-multihome2-R-2 -
	sctp-multihome3-3Timeout -
	sctp-multipleDropsSameWnd-1  -
	sctp-multipleDropsSameWnd-1-delayed  -
	sctp-multipleDropsSameWnd-2  -
	sctp-multipleDropsSameWnd-3  -
	sctp-multipleDropsTwoWnds-1-delayed  -
	sctp-multipleRtx  -
	sctp-multipleRtx-early  -
	sctp-noEarlyHBs -
	sctp-smallRwnd  -
	sctp-zeroRtx  -
	sctp-zeroRtx-burstLoss -
	sctp-hbAfterRto-2packetsTimeout -
	sctp-hbAfterRto-multihome2-2Timeout -
	sctp-multipleFastRtx-2packetsTimeout -
	sctp-multipleFastRtx-multihome2-2Timeout -
	sctp-newReno -
	sctp-timestamp-multihome2-2Rtx3 -
	sctp-timestamp-multihome2-2Timeout {
	    set t [new Test/$test]
	}
	default {
	    puts stderr "Unknown test $test"
	    exit 1
	}
    }
    $t run
}

global argv arg0
runtest $argv
