\# Project 3 — The Morning Brief with a Memory



\## Objective



Build a scheduled-style morning brief that remembers what happened during the previous run.



This project demonstrates:



\- Scheduled loop concept

\- State and memory

\- The spine

\- Repository-based context

\- Repeated runs that build on previous runs



\## Project Structure



\- `TODO.md` — repository information used by the morning brief

\- `progress.md` — persistent memory/spine between runs

\- `morning-brief.bat` — morning brief workflow

\- `README.md` — project documentation



\## How It Works



Each run performs these steps:



1\. Read the previous `progress.md`.

2\. Read the current TODO information.

3\. Review recent Git commits.

4\. Create a short morning brief.

5\. Update `progress.md` with the date and findings.



\## First Run



The first run:



\- Read the repository TODO list.

\- Reviewed recent Git commits.

\- Created the initial memory in `progress.md`.



\## Second Run



Before the second run, new information was added to the repository.



The second run:



\- Read the existing `progress.md`.

\- Read the current TODO list.

\- Reviewed the new Git commit.

\- Recorded the new information.

\- Updated the memory for the next run.



\## Memory / Spine



`progress.md` is the persistent spine of this loop.



It connects one run to the next.



Without `progress.md`, each run would start without knowledge of previous work.



\## Acceptance Test



Project 3 passes when:



\- The loop can run twice.

\- The second run reads the memory created by the first run.

\- The second run identifies new information.

\- The second run updates `progress.md`.

\- Previously completed work is not treated as new work.



\## Result



The project demonstrates that repository state can carry memory between separate runs.



\## Course Concept



This project demonstrates Concept 6 (unattended schedule) and Concept 12 (the spine) from the Panaversity Loop Engineering Crash Course.

