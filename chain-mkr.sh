#!/bin/bash

Create_Chain() {
  echo "Which Chain? INPUT (I), FORWARD (F), or OUTPUT (O)"
  echo
  read CHAIN
  echo
  if [[ $CHAIN == [I,i] ]] ; then
    echo "Creating rule for INPUT Chain"
    CHAIN_1="iptables -I INPUT 1 "
    ((VAR1++))
  elif [[ $CHAIN == [F,f] ]] ; then
    echo "Creating rule for FORWARD Chain"
    CHAIN_1="iptables -I FORWARD 1 "
    ((VAR1++))
  elif [[ $CHAIN == [O,o] ]] ; then
    echo "Creating rule for OUTPUT Chain"
    CHAIN_1="iptables -I OUTPUT 1 "
    ((VAR1++))
  else
    echo "Invalid Selction! Please Try again"
    Create_Chain
  fi
}

VAR1=1

echo
echo "Create new Rule (C), Edit Existing Rule (E), Delete Rule (D), Exit (X)"
echo
read CHOICE
echo
if [[ $CHOICE == [C,c] ]] ; then
  while [ $VAR1 -eq 1 ]
    do
      Create_Chain
    done

#    echo
#    echo "Which protocol? TCP (T), UDP (U), or ICMP (I)
#    echo
#    read PROT_CH
#    echo
#    if [[ $PROT_CH == [T,t] ]] ; then
#      RULE_PROTO_1="-p tcp"
