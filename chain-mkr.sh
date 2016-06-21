#!/bin/bash

Create_Chain() {
  echo "Which Chain? INPUT (I), FORWARD (F), OUTPUT (O), Exit (X)"
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
  elif [[ $CHAIN == [X,x] ]] ; then
    ((VAR1++))
  else
    echo "Invalid Selction! Please Try again"
    Create_Chain
  fi
}

Edit_Chain() {
  echo "Which Chain? INPUT (I), FORWARD (F), OUTPUT (O), Exit (X)"
  echo
  read SELECT
  echo
    if [[ $SELECT == [I,i] ]] ; then
    EDIT_CHAIN="INPUT"
    elif [[ $SELECT == [F,f] ]] ; then
    EDIT_CHAIN="FORWARD"
    elif [[ $SELECT == [O,o] ]] ; then
    EDIT_CHAIN="OUTPUT"
    elif [[ $SELECT == [X,x] ]] ; then
      ((VAR2++))
    else
      echo "Invalid option. Try again"
      Edit_Chain
    fi
  iptables -L $EDIT_CHAIN --line-numbers
  echo
  echo "Which rule would you like to edit?"
  echo 
  read RULE_NUM
  echo
}

VAR1=1
VAR2=1
VAR3=1
PROT1=1
STATE1=1

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
elif [[ $CHOICE == [E,e] ]] ; then
  while [ $VAR2 -eq 1 ]
    do
      Edit_Chain
    done
elif [[ $CHOICE == [D,d] ]] ; then
  while [ $VAR3 -eq 1 ]
    do
      Delete_Chain
    done
elif [[ $CHOICE == [X,x] ]] ; then
  exit
else
  
#    echo
#    echo "Which protocol? TCP (T), UDP (U), or ICMP (I)
#    echo
#    read PROT_CH
#    echo
#    if [[ $PROT_CH == [T,t] ]] ; then
#      RULE_PROTO_1="-p tcp"
