from typing import Dict, Any, Tuple
from  worktree import create_worktree, cleanup_worktree
from config import MAX_MODEL_API_COST, AUDIT_TARGET_DIR
from heartbeat import send_heartbeat
import os
import random

def simulate_dependency_audit(worktree_path: str) -> Dict[str, Any]:
    """Simulates auditing and fixing dependencies."""
    send_heartbeat("Maker_Audit")
    print(f"Maker: Auditing dependencies in {worktree_path}")
    changes = []

    # Simulate finding an outdated package in requirements.txt
    req_path = os.path.join(worktree_path, "requirements.txt")
    if os.path.exists(req_path):
        with open(req_path, 'r') as f:
            lines = f.readlines()
        
        new_lines = []
        fixed_a_dependency = False
        for line in lines:
            if 'old-package==1.0.0' in line:
                new_line = 'updated-package==2.0.0\n'
                changes.append({
                    "file": "requirements.txt",
                    "old_line": line.strip(),
                    "new_line": new_line.strip()
                })
                new_lines.append(new_line)
                fixed_a_dependency = True
            else:
                new_lines.append(line)
        
        if fixed_a_dependency:
            with open(req_path, 'w') as f:
                f.write(''.join(new_lines))
            print("Maker: Simulated fixing 'old-package' to 'updated-package'.")
    else:
        print(f"Maker: No requirements.txt found in {worktree_path}. Skipping audit.")

    # Simulate adding a new dependency if no fix was made, for demonstration purposes
    if not changes:
        with open(req_path, 'a') as f:
            f.write('new-dependency==1.0.0\n')
        changes.append({
            "file": "requirements.txt",
            "old_line": "",
            "new_line": "new-dependency==1.0.0"
        })
        print("Maker: Simulated adding 'new-dependency'.")

    # Simulate success or failure randomly for demonstration
    if random.random() < 0.8: # 80% chance of success
        return {"status": "COMPLETED", "message": "Audit and fix simulated successfully.", "changes": changes}
    else:
        return {"status": "FAILED", "message": "Simulated audit failure.", "changes": []}

def perform_dependency_audit(target_repo_path: str, current_total_cost: float) -> Tuple[Dict[str, Any], float]:
    """Orchestrates the maker's dependency audit process."""
    send_heartbeat("Maker_Orchestration")
    cost_of_maker_run = 0.5 # Simulate some cost for the maker operation

    if (current_total_cost + cost_of_maker_run) > MAX_MODEL_API_COST:
        return {"status": "FAILED", "message": "Maker cannot run, budget exceeded."}, 0.0
    
    worktree_path = None
    try:
        worktree_path = create_worktree(target_repo_path)
        audit_result = simulate_dependency_audit(worktree_path)
        return audit_result, cost_of_maker_run
    except Exception as e:
        return {"status": "FAILED", "message": f"Maker encountered an error: {e}"}, cost_of_maker_run
    finally:
        if worktree_path:
            cleanup_worktree(worktree_path)

if __name__ == "__main__":
    # Simulate a target repo for testing the maker
    current_dir = os.path.dirname(os.path.abspath(__file__))
    simulated_target_repo = os.path.join(current_dir, '..', 'simulated_target_repo')
    os.makedirs(simulated_target_repo, exist_ok=True)
    with open(os.path.join(simulated_target_repo, 'requirements.txt'), 'w') as f:
        f.write('old-package==1.0.0\nexisting-package==1.0.0\n')
    
    print("\n--- Running Maker Test ---")
    result, cost = perform_dependency_audit(simulated_target_repo, 0.0)
    print(f"Maker Test Result: {result}, Cost: {cost}")

    # Clean up simulated target repo
    import shutil
    if os.path.exists(simulated_target_repo):
        shutil.rmtree(simulated_target_repo)
