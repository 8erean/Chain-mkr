#!/bin/bash

################################################################################

Main() {

VAR1=1
VAR2=1
VAR3=1
VAR4=1
VAR5=1
DEL1=1

PROT1="protocol"
STATE1="state"
CHAIN_1="chain"
SERVICE_1="portNumber"
SRC_DEST_1="blockedHost"
JUMP_1="jump"
DEL_CHAIN="del_chain"

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
  while [ $DEL1 -eq 1 ]
    do
      Del_Rule
    done
elif [[ $CHOICE == [X,x] ]] ; then
  echo "Goodbye!"
  exit
else
  echo "Invalid Option! Try again."
fi
}

################################################################################

Create_Chain() {
  echo "Which Chain? INPUT (I), FORWARD (F), OUTPUT (O), Exit (X)"
  echo
  read CHAIN
  echo
  if [[ $CHAIN == [I,i] ]] ; then
    echo "Creating rule for INPUT Chain..."
    CHAIN_1="iptables -I INPUT 1 "
    while [ $VAR2 -eq 1 ]
      do
        Protocol
      done
    ((VAR1++))
    Main
  elif [[ $CHAIN == [F,f] ]] ; then
    echo "Creating rule for FORWARD Chain..."
    CHAIN_1="iptables -I FORWARD 1 "
    while [ $VAR2 -eq 1 ]
      do
        Protocol
      done
    ((VAR1++))
        Main
  elif [[ $CHAIN == [O,o] ]] ; then
    echo "Creating rule for OUTPUT Chain..."
    CHAIN_1="iptables -I OUTPUT 1 "
    while [ $VAR2 -eq 1 ]
      do
        Protocol
      done
    ((VAR1++))
    Main
  elif [[ $CHAIN == [X,x] ]] ; then
    ((VAR1++))
    echo "Exiting Chain Creation, back to Main Menu..."
    Main
  else
    echo "Invalid Selction! Please Try again"
    Create_Chain
  fi
}

################################################################################

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
    while [ $VAR3 -eq 1 ]
      do
        Service
      done
    ((VAR2++))
  elif [[ $INPUT == [U,u] ]] ; then
    PROT1="-p udp "
    echo
    echo "Now it's time to add a Service/Port"
    echo
    while [ $VAR3 -eq 1 ]
      do
        Service
      done
    ((VAR2++))
  elif [[ $INPUT == [I,i] ]] ; then
    echo "This will set you up to block or allow standard pings."
    PROT1="-p icmp --icmp-type echo-reply "
    echo
    echo "Would you like to add a source IP address or range? Y/N?"
    read INPUT2
      if [[ $INPUT2 == [Y,y] ]] ; then
        echo
        while [ $VAR4 -eq 1 ]
          do
            Source_Dest
          done
        ((VAR2++))
      elif [[ $INPUT2 == [N,n] ]] ; then
        echo
        echo "Ok then."
        echo "Now it's time to Accept or Deny"
        echo
          while [ $VAR5 -eq 1 ]
            do
              Jump
            done
          ((VAR2++))
      else
        echo "Invalid option. Try again."
        Protocol
      fi
  else
    echo "Invalid option. Try again."
    Protocol
  fi
}

################################################################################

Service() {
  echo "Which service would you like to use? Port number: "
  read SRV_NUM
  SERVICE_1="--dport $SRV_NUM "
  echo
  echo
  echo "Would you like to block a source IP address or range? Y/N?"
  read INPUT3
    if [[ $INPUT3 == [Y,y] ]] ; then
      echo
      while [ $VAR4 -eq 1 ]
        do
          Source_Dest
        done
      ((VAR3++))
    elif [[ $INPUT3 == [N,n] ]] ; then
      echo
      echo "Ok then."
      echo "Now it's time to Accept or Deny"
      echo
        while [ $VAR5 -eq 1 ]
          do
            Jump
          done
        ((VAR3++))
    else
    echo "Invalid option. Try again."
      Service
    fi
}

################################################################################

Source_Dest() {
  echo
  echo "Please type in the IP address, range of addresses, or CIDR network"
  echo
  read IP_ADDR
  SRC_DEST_1="-s $IP_ADDR "
  echo
  echo "Now it's time to Accept or Deny"
  echo
    while [ $VAR5 -eq 1 ]
      do
        Jump
      done
    ((VAR4++))
}

################################################################################

Jump() {
  echo
  echo "Would you like to Accept (A), Reject (R), or Drop (D) traffic?"
  read JUMPER
  if [[ $JUMPER == [A,a] ]] ; then
    JUMP_1="-j ACCEPT "
  elif [[ $JUMPER == [R,r] ]] ; then
    JUMP_1="-j REJECT "
  elif [[ $JUMPER == [D,d] ]] ; then
    JUMP_1="-j DROP "
  else
    echo "Invalid option. Try again."
  fi
  echo
  echo
  echo
  echo
  echo "Congrats!!! You have completed a firewall rule!"
  echo "Here is what it looks like..."
  echo
  echo
  if [[ $SERVICE_1 == 'portNumber' ]] && [[ $SRC_DEST_1 == 'blockedHost' ]]
  then
      echo $CHAIN_1$PROT1$JUMP_1
      echo
      echo
      echo "Would you like to commit? Y/N "
      read COMMIT
        if [[ $COMMIT == [Y,y] ]] ; then
          $CHAIN_1$PROT1$JUMP_1
          ((VAR5++))
          Main
        elif [[ $COMMIT == [N,n] ]] ; then
          echo "Sorry it didn't work. Try again."
          ((VAR5++))
          Main
        else
          echo "Invalid option. Try again."
          Jump
        fi
    elif [[ $SERVICE_1 != 'portNumber' ]] && [[ $SRC_DEST_1 == 'blockedHost' ]]
    then
        echo $CHAIN_1$PROT1$SERVICE_1$JUMP_1
        echo
        echo
        echo "Would you like to commit? Y/N "
        read COMMIT2
          if [[ $COMMIT2 == [Y,y] ]] ; then
            $CHAIN_1$PROT1$SERVICE_1$JUMP_1
            ((VAR5++))
            Main
          elif [[ $COMMIT2 == [N,n] ]] ; then
            echo "Sorry it didn't work. Try again."
            ((VAR5++))
            Main
          else
            echo "Invalid option. Try again."
            Jump
          fi
    elif [[ $SERVICE_1 == 'portNumber' ]] && [[ $SRC_DEST_1 != 'blockedHost' ]]
    then
        echo $CHAIN_1$PROT1$SRC_DEST_1$JUMP_1
        echo
        echo
        echo "Would you like to commit? Y/N "
        read COMMIT
          if [[ $COMMIT == [Y,y] ]] ; then
            $CHAIN_1$PROT1$SRC_DEST_1$JUMP_1
            ((VAR5++))
            Main
          elif [[ $COMMIT == [N,n] ]] ; then
            echo "Sorry it didn't work. Try again."
            ((VAR5++))
            Main
          else
            echo "Invalid option. Try again."
            Jump
          fi
      else
        echo $CHAIN_1$PROT1$SERVICE_1$SRC_DEST_1$JUMP_1
        echo
        echo
        echo "Would you like to commit? Y/N "
        read COMMIT
          if [[ $COMMIT == [Y,y] ]] ; then
            $CHAIN_1$PROT1$SERVICE_1$SRC_DEST_1$JUMP_1
            ((VAR5++))
            Main
          elif [[ $COMMIT == [N,n] ]] ; then
            echo "Sorry it didn't work. Try again."
            ((VAR5++))
            Main
          else
            echo "Invalid option. Try again."
            Jump
          fi
      fi
}

################################################################################

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
      ((DEL1++))
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

################################################################################

Main
