CPATH='.:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar'

rm -rf student-submission
rm -rf grading-area


mkdir grading-area

git clone $1 student-submission 2> ta-output.txt
echo 'Finished cloning'


# Draw a picture/take notes on the directory structure that's set up after
# getting to this point

# Then, add here code to compile and run, and do any post-processing of the
# tests


# check that the student submitted the right file 
if [[ -f "student-submission/ListExamples.java" ]]
then
    echo "File found!"
else
    echo "ListExamples.java not found! Score: 0"
    exit 1  # nonzero exit code to show there was an error
fi


# jar
cp -r lib grading-area
# ListExamples
cp student-submission/ListExamples.java grading-area/
# TestListExamples
cp TestListExamples.java grading-area/

# compile 

cd grading-area
javac -cp $CPATH *.java

# check for a compile error 
if [[ $? -ne 0 ]]
then
  echo "Compile error! Score: 0"
  exit 1
else 
    echo "Compiled successfully"
fi


java -cp $CPATH org.junit.runner.JUnitCore TestListExamples > junit-output.txt





# echo "Your score is $successes / $tests"



echo $lastline

if [[ $(grep -c "OK" "junit-output.txt") -ne 0 ]]
then
echo "Code passed all tests! Score: 1/1"
else
lastline=$(cat junit-output.txt | tail -n 2 | head -n 1)
tests=$(echo $lastline | awk -F'[, ]' '{print $3}')
failures=$(echo $lastline | awk -F'[, ]' '{print $6}')
successes=$((tests - failures)) 
echo "Code did not pass all tests. Score: $successes / $tests"
fi
