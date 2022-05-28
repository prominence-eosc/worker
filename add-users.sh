#!/bin/sh
for i in {1..96}
do
   id=$(printf "user%02d" $i)
   useradd $id
done
