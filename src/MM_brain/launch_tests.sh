TEST_NUM=$(ls -1 bin/*_test | wc -l)
echo Running $TEST_NUM tests 
i=0
for f in $(ls -1 bin/*_test)
do
   i=$(expr $i + 1)
   echo "Test ($i/$TEST_NUM):" 
   ./$f 2&>1 /dev/null
   retVal=$?
   if [ $retVal -ne 0 ]; then
       echo "Test not passed"
   else 
      echo "Test passed!"
   fi
done
