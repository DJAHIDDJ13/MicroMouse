TEST_NUM=$(ls -1 bin/*_test | wc -l)
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color
echo Running $TEST_NUM tests 
i=0
for f in $(ls -1 bin/*_test)
do
   i=$(expr $i + 1)
   echo "Test ($i/$TEST_NUM): $f" 

   ./$f

   retVal=$?
   if [ $retVal -ne 0 ]; then
       printf "${RED}Test not passed${NC}\n"
   else 
      printf "${GREEN}Test passed!${NC}\n"
   fi
done
