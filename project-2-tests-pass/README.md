\# Project 2 — Make the Tests Pass, Then Stop



\## Objective



This project demonstrates a conditional engineering loop that continues until an external test command reports PASS.



The loop does not rely on an agent saying that the task is complete.



\## Project Structure



\- `app.js` — application code

\- `test.js` — test checker

\- `loop.bat` — conditional loop

\- `README.md` — project documentation



\## Tests



The project contains three tests:



1\. `add(2, 3)` should return `5`

2\. `add(10, 5)` should return `15`

3\. `multiply(3, 4)` should return `12`



\## Initial State



The application initially contained incorrect implementations.



The test command produced:



\- Passed: 0

\- Failed: 3



This demonstrated that the checker correctly detected failing work.



\## Fix



The application functions were corrected and the tests were run again.



Final result:



\- Passed: 3

\- Failed: 0



\## Conditional Loop



`loop.bat` runs the test command repeatedly.



The loop:



1\. Runs `node test.js`

2\. Checks the test result

3\. Stops when tests pass

4\. Continues when tests fail

5\. Stops after a maximum of 6 attempts if tests never pass



\## Stopping Condition



The external test runner is the stopping condition.



The loop successfully stops only when:



`node test.js`



returns a successful exit code.



The agent/developer does not decide whether the task is complete.



\## Maker-Checker Pattern



Maker:

\- Modifies or fixes the application code.



Checker:

\- Runs `node test.js` to verify the result.



The checker determines whether the loop should stop.



\## Verification



The project was verified with initially failing tests and then with the corrected implementation.



Final verification:



```text

PASS: add 2 + 3

PASS: add 10 + 5

PASS: multiply 3 \* 4



Passed: 3

Failed: 0

