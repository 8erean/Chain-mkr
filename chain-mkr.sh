#!/bin/bash

Main() {
echo
echo
echo "Create new Rule (C), Delete Rule (D), Exit (X)"
echo
read CHOICE
echo
if [[ $CHOICE == [C,c] ]] ; then
  while [ $VAR1 -eq 1 ]
    do
      Create_Chain
    done
elif [[ $CHOICE == [D,d] ]] ; then
  while [ $VAR2 -eq 1 ]
    do
      Del_Chain
    done
elif [[ $CHOICE == [X,x] ]] ; then
  echo "Goodbye!"
  exit
else
  echo "Invalid Option! Try again."
fi
}


Create_Chain() {
  echo "Which Chain? INPUT (I), FORWARD (F), OUTPUT (O), Exit (X)"
  echo
  read CHAIN
  echo
  if [[ $CHAIN == [I,i] ]] ; then
    echo "Creating rule for INPUT Chain"
    CHAIN_1="iptables -I INPUT 1 "
    ((VAR1++))
    Protocol
  elif [[ $CHAIN == [F,f] ]] ; then
    echo "Creating rule for FORWARD Chain"
    CHAIN_1="iptables -I FORWARD 1 "
    ((VAR1++))
    Protocol
  elif [[ $CHAIN == [O,o] ]] ; then
    echo "Creating rule for OUTPUT Chain"
    CHAIN_1="iptables -I OUTPUT 1 "
    ((VAR1++))
    Protocol
  elif [[ $CHAIN == [X,x] ]] ; then
    ((VAR1++))
    echo "Exiting Chain Creation, back to Main Menu..."
    Main
  else
    echo "Invalid Selction! Please Try again"
    Create_Chain
  fi
}

Del_Rule() {
  echo "Which Chain? INPUT (I), FORWARD (F), OUTPUT (O), Exit (X)"
  echo
  read SELECT
  echo
    if [[ $SELECT == [I,i] ]] ; then
    DEL_CHAIN="INPUT"
    elif [[ $SELECT == [F,f] ]] ; then
    DEL_CHAIN="FORWARD"
    elif [[ $SELECT == [O,o] ]] ; then
    DEL_CHAIN="OUTPUT"
    elif [[ $SELECT == [X,x] ]] ; then
      ((VAR2++))
      echo "Exiting Rule Deletion, back to Main Menu..."
      Main
    else
      echo "Invalid option. Try again"
      Del_Chain
    fi
  iptables -L $DEL_CHAIN --line-numbers
  echo
  echo "Which rule would you like to delete?"
  echo 
  read RULE_NUM
  echo
  iptables -L $DEL_CHAIN --line-numbers | grep ^$RULE_NUM >> /tmp/iptables_edit_rule.log
  iptables -D $DEL_CHAIN $RULE_NUM
  iptables -L $DEL_CHAIN
  echo "***Rule successfully Deleted***"
}

Protocol() {
  echo
  echo "Which protocol? TCP (T), UDP (U), ICMP (I), or Exit (X)"
  echo
  read INPUT
  if [[ $INPUT == [T,t] ]] ; then
    PROT1="-p tcp "
    echo
    echo "Now it's time to add a Service/Port."
    echo
    ((VAR2++))
    
}

Service() {
  #placeholder for the Service Function
}

Source_Dest() {
  #placeholder for the Source_Dest Function
}

Jump() {
  #placeholder for the Jump Function
}

VAR1=1
VAR2=1

PROT1="protocol"
STATE1="state"
CHAIN_1="chain"
DEL_CHAIN="del_chain"

Main
  
#    echo
#    echo "Which protocol? TCP (T), UDP (U), or ICMP (I)
#    echo
#    read PROT_CH
#    echo
#    if [[ $PROT_CH == [T,t] ]] ; then
#      RULE_PROTO_1="-p tcp"
