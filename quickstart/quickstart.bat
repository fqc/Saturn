@echo off
cd ..
echo [Step 1] Buidling Saturn, take a coffee
call mvn clean package -Dmaven.javadoc.skip=true -Dmaven.test.skip=true 

echo [Step 2] Running Saturn Console, visit http://localhost:9088 after a few seconds
set base_dir=%cd%
set REG_CENTER_JSON_PATH=%base_dir%\quickstart\quickstart-json.txt
start "saturn console" java -Dsaturn.embeddedzk=true -Dsaturn.stdout=true -jar saturn-console/target/saturn-console-master-SNAPSHOT.jar

echo [Step 3] Running Saturn Executor
cd saturn-executor\target
set VIP_SATURN_ZK_CONNECTION=localhost:2182
jar xf saturn-executor-master-SNAPSHOT-zip.zip
cp %base_dir%\quickstart\demo-java-job.jar -r %base_dir%\saturn-executor\target\saturn-executor-master-SNAPSHOT\lib
start "saturn executor" java -Xms256m -Xmx256m -Xss256K -Dsaturn.log=saturn-job-executor.log -Dlog.folder=executor-1 -Dsaturn.stdout=true -Dstart.check.outfile=status  -jar saturn-executor-master-SNAPSHOT.jar  -namespace mydomain -executorName executor-1 -saturnLibDir %cd%\saturn-executor-master-SNAPSHOT -appLibDir %cd%\saturn-executor-master-SNAPSHOT\lib 
sleep 10

echo [Step 4] Add a demo java job
cd %base_dir%\saturn-executor\target\saturn-executor-master-SNAPSHOT
mkdir %base_dir%\saturn-executor\target\saturn-executor-master-SNAPSHOT\demo
cp %base_dir%\quickstart\DemoJavaJob.class -r %base_dir%\saturn-executor\target\saturn-executor-master-SNAPSHOT\demo
set LIB_JARS=lib\*;%CLASSPATH%
java -cp %LIB_JARS% demo/DemoJavaJob

echo [Step 5] Done, visit http://localhost:9088 for more
@echo on

pause
