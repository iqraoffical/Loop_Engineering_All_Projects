from typing import Dict, Any
from maker import perform_dependency_audit
from checker import review_dependency_audit
from connector import create_pull_request
from config import MAX_ATTEMPTS, MAX_RUNTIME_SECONDS, MAX_MODEL_API_COST, MAX_TOTAL_SPENDING
from heartbeat import send_heartbeat
import time

def execute_dependency_audit_skill(target_repo_path: str) -> Dict[str, Any]:
    """Executes the dependency audit skill, including Maker, Checker, and Connector."""
    send_heartbeat("Skill_DependencyAudit")
    audit_result = {"status": "FAIL", "message": "", "pr_url": None}

    attempts = 0
    start_time = time.time()
    current_cost = 0.0

    while attempts < MAX_ATTEMPTS:
        attempts += 1
        if (time.time() - start_time) > MAX_RUNTIME_SECONDS:
            audit_result["message"] = "Skill execution timed out."
            return audit_result
        if current_cost > MAX_TOTAL_SPENDING:
            audit_result["message"] = "Skill execution exceeded total spending budget."
            return audit_result

        print(f"\n--- Attempt {attempts} for Dependency Audit ---")
        maker_output, maker_cost = perform_dependency_audit(target_repo_path, current_cost)
        current_cost += maker_cost

        if current_cost > MAX_MODEL_API_COST:
            audit_result["message"] = "Maker model API cost exceeded budget."
            return audit_result

        if maker_output["status"] == "COMPLETED":
            checker_review, checker_cost = review_dependency_audit(maker_output, current_cost)
            current_cost += checker_cost

            if current_cost > MAX_MODEL_API_COST:
                audit_result["message"] = "Checker model API cost exceeded budget."
                return audit_result

            if checker_review["status"] == "PASS":
                print("Checker: PASS. Proceeding to Connector.")
                pr_url = create_pull_request(maker_output["changes"], target_repo_path)
                audit_result["status"] = "PASS"
                audit_result["message"] = "Dependency audit successful and PR created."
                audit_result["pr_url"] = pr_url
                return audit_result
            else:
                print(f"Checker: FAIL. Reason: {checker_review["message"]}")
                audit_result["message"] = f"Checker failed on attempt {attempts}: {checker_review["message"]}"
        else:
            print(f"Maker: FAILED. Reason: {maker_output["message"]}")
            audit_result["message"] = f"Maker failed on attempt {attempts}: {maker_output["message"]}"

    audit_result["message"] = f"Dependency audit failed after {MAX_ATTEMPTS} attempts."
    return audit_result

if __name__ == "__main__":
    # Simulate a target repo for testing the skill
    import os
    current_dir = os.path.dirname(os.path.abspath(__file__))
    simulated_target_repo = os.path.join(current_dir, '..', 'simulated_target_repo')
    os.makedirs(simulated_target_repo, exist_ok=True)
    with open(os.path.join(simulated_target_repo, 'requirements.txt'), 'w') as f:
        f.write('old-package==1.0.0\n')
    
    print("\n--- Running Dependency Audit Skill Test ---")
    result = execute_dependency_audit_skill(simulated_target_repo)
    print(f"\nSkill Test Result: {result}")

    # Clean up simulated target repo
    import shutil
    if os.path.exists(simulated_target_repo):
        shutil.rmtree(simulated_target_repo)
