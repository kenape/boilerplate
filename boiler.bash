#!/usr/bin/env bash

function usage-for-afunction() {
  echo "Usage: ${1} [OPTIONS] positionalone postiionaltwo
Does something wiht optional [OPTIONS] supplied and mandatory positionalone and positionaltwo

OPTIONS:
  -h, --help           display this help and exit
  -n --argnovalue      optional argument without value
  -w --argwithvalue    optional argument with value
"
}

afunction() {
positionalargs=()    # init empty array

while [[ $# -gt 0 ]]; do
  case $1 in
    -h|--help)
      usage-for-afunction ${FUNCNAME[0]}
      return 0
      ;;
    -w|--argwithvalue)
      valueforargwithvalue="$2"
      shift    # shift past the argument
      shift    # shift past the value
      ;;
    -n|--argnovalue)
      canuseforswitch='--canuseforswitch'    # e.g. use it to pass --insecure to underlying OpenStack commands
      shift    # shift past the argument
      ;;
    -*|--*)
      echo "Unknown option $1" >&2
      usage-for-afunction ${FUNCNAME[0]}
      return 1
      ;;
    *)
      positionalargs+=("$1")    # add positional arg to the array
      shift # past argument
      ;;
  esac
done

if [[ ${#positionalargs[@]} -eq 2 ]]; then
  positionalone=${positionalargs[0]}; positionaltwo=${positionalargs[1]}    # e.g. for mv command this would be 'source' and 'destination'
else
  echo "Error: Wrong number of mandatory arguments supplied" >&2
  usage-for-afunction ${FUNCNAME[0]}
  return 1
fi

echo "value for -w|--argwithvalue:    ${valueforargwithvalue}"
echo "  value for canuseforswtich:    ${canuseforswitch}    # <<<< Empty if you didn't pass -n|--argnovalue, --canuseforswtich otherwise"
echo "     positional args passed:    ${positionalargs[@]}"
echo "       so, positionalone is:    ${positionalone}"
echo "       and positionaltwo is:    ${positionaltwo}"

set -- "${positionalargs[@]}"    # restore positional parameters
unset valueforargwithvalue canuseforswitch positionalone positionaltwo
}

echo '# # # TEST no mandatories # # #'
echo '# # # Will call: afunction ; echo "Exit code: $?" # # #'
afunction ; echo "Exit code: $?"
echo '# # # TEST call help # # #'
echo '# # # Will call: afunction --help ; echo "Exit code: $?" # # #'
afunction --help ; echo "Exit code: $?"
echo '# # # TEST use one argument # # #'
echo '# # # Will call: afunction --argnovalue one two; echo "Exit code: $?" # # #'
afunction --argnovalue one two; echo "Exit code: $?"
echo '# # # TEST use both arguments # # #'
echo '# # # Will call: afunction --argnovalue --argwithvalue avalue one two; echo "Exit code: $?" # # #'
afunction --argnovalue --argwithvalue avalue one two; echo "Exit code: $?"
