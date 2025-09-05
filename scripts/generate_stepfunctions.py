#!/usr/bin/env python3
import json

def generate_branch(branch_id):
    """Generate a single branch with 20 sequential steps"""
    states = {}
    
    for step in range(1, 21):
        step_name = f"Branch{branch_id}_Step{step}"
        
        state = {
            "Type": "Task",
            "Resource": "arn:aws:states:::lambda:invoke",
            "Parameters": {
                "FunctionName": "${lambda_function_arn}",
                "Payload.$": "States.ArrayGetItem(States.Array($.payloads.greet_payload, $.payloads.upper_payload), States.MathRandom(0, 1))"
            },
            "ResultPath": "$.lambda_result"
        }
        
        if step < 20:
            state["Next"] = f"Branch{branch_id}_Step{step + 1}"
        else:
            state["End"] = True
            
        states[step_name] = state
    
    return {
        "StartAt": f"Branch{branch_id}_Step1",
        "States": states
    }

def generate_step_functions_definition():
    """Generate the complete Step Functions definition"""
    branches = []
    
    # Generate 10 parallel branches
    for i in range(10):
        branches.append(generate_branch(i))
    
    definition = {
        "Comment": "10 parallel branches, each executing 20 sequential Lambda calls with random payload selection",
        "StartAt": "InitializePayloads",
        "States": {
            "InitializePayloads": {
                "Type": "Pass",
                "Result": {
                    "payloads": {
                        "greet_payload": {
                            "headers": { "spring.cloud.function.definition": "greet" },
                            "payload": { "name": "Alice" }
                        },
                        "upper_payload": {
                            "headers": { "spring.cloud.function.definition": "upper" },
                            "payload": "hello world from step functions"
                        }
                    }
                },
                "Next": "ParallelExecution"
            },
            "ParallelExecution": {
                "Type": "Parallel",
                "Branches": branches,
                "Next": "Success"
            },
            "Success": {
                "Type": "Succeed"
            }
        }
    }
    
    return definition

if __name__ == "__main__":
    definition = generate_step_functions_definition()
    
    # Write to the terraform directory
    with open("../terraform/step_functions_definition.json", "w") as f:
        json.dump(definition, f, indent=2)
    
    print("Step Functions definition generated successfully!")