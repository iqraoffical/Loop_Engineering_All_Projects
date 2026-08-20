from typing import Dict, Any, Tuple
from config import MAX_MODEL_API_COST
from heartbeat import send_heartbeat

def review_dependency_audit(maker_output: Dict[str, Any], current_total_cost: float) -> Tuple[Dict[str, Any], float]:
    """Independently reviews the maker's dependency audit and fixes."""
    send_heartbeat("Checker_Review")
    cost_of_checker_run = 0.2 # Simulate some cost for the checker operation

    if (current_total_cost + cost_of_checker_run) > MAX_MODEL_API_COST:
        return {"status": "FAIL", "message": "Checker cannot run, budget exceeded."}, 0.0

    print("Checker: Reviewing Maker's output...")
    changes = maker_output.get("changes", [])

    if not changes:
        # If maker made no changes, it could be a pass if no issues were found, or a fail if it missed something.
        # For this simulation, we'll make it a fail if no changes were proposed, implying it missed something.
        return {"status": "FAIL", "message": "No changes proposed by Maker. Audit might be incomplete."}, cost_of_checker_run

    # Simulate a review process
    # In a real scenario, this would involve more sophisticated analysis:
    # - Checking if new dependencies are valid/approved
    # - Verifying that outdated dependencies are actually updated to correct versions
    # - Ensuring no breaking changes were introduced
    
    # For simulation, we'll just check if there's at least one proposed change
    # and if the simulated package update is present.
    passed_review = False
    for change in changes:
        if "requirements.txt" in change["file"] and "updated-package==2.0.0" in change["new_line"]:
            passed_review = True
            break
        if "requirements.txt" in change["file"] and "new-dependency==1.0.0" in change["new_line"]:
            passed_review = True
            break

    if passed_review:
        print("Checker: Review PASSED. Proposed changes seem reasonable.")
        return {"status": "PASS", "message": "Changes reviewed and approved."}, cost_of_checker_run
    else:
        print("Checker: Review FAILED. Proposed changes are not as expected or incomplete.")
        return {"status": "FAIL", "message": "Proposed changes did not meet review criteria."}, cost_of_checker_run

if __name__ == "__main__":
    print("\n--- Running Checker Test (Simulated Maker Output - PASS) ---")
    mock_maker_output_pass = {
        "status": "COMPLETED",
        "message": "Audit and fix simulated successfully.",
        "changes": [
            {
                "file": "requirements.txt",
                "old_line": "old-package==1.0.0",
                "new_line": "updated-package==2.0.0"
            }
        ]
    }
    result_pass, cost_pass = review_dependency_audit(mock_maker_output_pass, 0.0)
    print(f"Checker Test Result (PASS): {result_pass}, Cost: {cost_pass}")

    print("\n--- Running Checker Test (Simulated Maker Output - FAIL - no changes) ---")
    mock_maker_output_fail_no_changes = {
        "status": "COMPLETED",
        "message": "No issues found.",
        "changes": []
    }
    result_fail_no_changes, cost_fail_no_changes = review_dependency_audit(mock_maker_output_fail_no_changes, 0.0)
    print(f"Checker Test Result (FAIL - no changes): {result_fail_no_changes}, Cost: {cost_fail_no_changes}")

    print("\n--- Running Checker Test (Simulated Maker Output - FAIL - unexpected changes) ---")
    mock_maker_output_fail_unexpected = {
        "status": "COMPLETED",
        "message": "Audit and fix simulated successfully.",
        "changes": [
            {
                "file": "requirements.txt",
                "old_line": "some-package==1.0.0",
                "new_line": "different-package==3.0.0"
            }
        ]
    }
    result_fail_unexpected, cost_fail_unexpected = review_dependency_audit(mock_maker_output_fail_unexpected, 0.0)
    print(f"Checker Test Result (FAIL - unexpected changes): {result_fail_unexpected}, Cost: {cost_fail_unexpected}")
