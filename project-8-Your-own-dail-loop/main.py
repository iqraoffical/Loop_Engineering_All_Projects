import time
from heartbeat import send_heartbeat
from skill import execute_dependency_audit_skill
from config import MAX_ATTEMPTS, MAX_RUNTIME_SECONDS, AUDIT_TARGET_DIR
import os
import shutil

def main():
    send_heartbeat("Spine_Start")
    print("\n--- Project 8 Loop Engineering Capstone: Spine Activated ---")

    global_attempts = 0
    global_start_time = time.time()

    # Simulate a target repository for the audit
    # In a real scenario, this would be the actual repository to audit
    # For this exercise, we'll create a dummy one for demonstration.
    if os.path.exists(AUDIT_TARGET_DIR):
        shutil.rmtree(AUDIT_TARGET_DIR)
    os.makedirs(AUDIT_TARGET_DIR, exist_ok=True)
    with open(os.path.join(AUDIT_TARGET_DIR, 'requirements.txt'), 'w') as f:
        f.write('old-package==1.0.0\nexisting-package==1.0.0\n')
    print(f"Created simulated target repository at: {AUDIT_TARGET_DIR}")

    while global_attempts < MAX_ATTEMPTS:
        global_attempts += 1
        current_runtime = time.time() - global_start_time

        if current_runtime > MAX_RUNTIME_SECONDS:
            print(f"Spine: Global runtime budget ({MAX_RUNTIME_SECONDS}s) exceeded. Stopping loop.")
            break

        print(f"\nSpine: Global Attempt {global_attempts}/{MAX_ATTEMPTS}. Current Runtime: {current_runtime:.2f}s")
        send_heartbeat("Spine_LoopIteration")

        # Execute the Dependency Audit Skill
        skill_result = execute_dependency_audit_skill(AUDIT_TARGET_DIR)

        if skill_result["status"] == "PASS":
            print(f"\nSpine: Skill completed successfully! PR URL: {skill_result["pr_url"]}")
            print("Spine: Loop completed and stopped.")
            break
        else:
            print(f"\nSpine: Skill failed: {skill_result["message"]}. Retrying...")
            if global_attempts == MAX_ATTEMPTS:
                print("Spine: Max global attempts reached. Stopping loop.")
    
    # Clean up the simulated target repository
    if os.path.exists(AUDIT_TARGET_DIR):
        shutil.rmtree(AUDIT_TARGET_DIR)
        print(f"Cleaned up simulated target repository at: {AUDIT_TARGET_DIR}")

    send_heartbeat("Spine_End")
    print("--- Project 8 Loop Engineering Capstone: Spine Deactivated ---")

if __name__ == "__main__":
    main()
