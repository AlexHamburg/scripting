#!/bin/bash

jps

echo "Enter PID of JBOSS:"
read pid

jstack ${pid} > /threadDump.tdump
jmap -dump:live,format=b,file=heapDump.hprof ${pid} 