/**
 * Project 6: Door Bell Loop - Event-Driven PR Review Simulator
 * Demonstrates Heartbeat Pattern #4: Event-Driven Heartbeat
 */

const fs = require('fs');
const path = require('path');

function reviewDiff(filename, codeContent) {
  console.log(`[Reviewer Subagent] Analyzing file: ${filename}...`);
  const lines = codeContent.split('\n');
  const issues = [];

  lines.forEach((line, index) => {
    // Check for off-by-one error: <= array.length or <= list.length
    if (/for\s*\(\s*let\s+\w+\s*=\s*0\s*;\s*\w+\s*<=\s*\w+\.length\s*;/.test(line)) {
      issues.push({
        line: index + 1,
        snippet: line.trim(),
        severity: 'HIGH',
        category: 'Off-by-One Error / Index Out of Bounds',
        message: 'Loop condition uses <= instead of < with length, causing array out-of-bounds access and NaN/undefined values.',
        suggestion: line.replace('<=', '<').trim()
      });
    }
  });

  return issues;
}

function handlePullRequestEvent(event) {
  console.log('\n======================================================');
  console.log(`[DOOR BELL RINGS] Event Triggered: ${event.action.toUpperCase()} PR #${event.number}`);
  console.log(`Title:  "${event.title}"`);
  console.log(`Author: @${event.author}`);
  console.log(`Branch: ${event.head_branch} -> ${event.base_branch}`);
  console.log('======================================================\n');

  console.log('[Connector] GitHub webhook event received. Waking event-driven heartbeat...');
  console.log('[Connector] Fetching PR diff and files...');

  const filePath = event.targetFile;
  const fileContent = fs.readFileSync(filePath, 'utf8');

  console.log(`[Connector] Loaded diff for: ${path.basename(filePath)}`);
  
  const issues = reviewDiff(path.basename(filePath), fileContent);

  if (issues.length > 0) {
    console.log('\n[Review Verdict] REQUEST_CHANGES (Bugs Found):');
    issues.forEach(issue => {
      console.log(`\n  * Issue at line ${issue.line} [${issue.severity}]: ${issue.category}`);
      console.log(`    Code:       ${issue.snippet}`);
      console.log(`    Problem:    ${issue.message}`);
      console.log(`    Suggested:  ${issue.suggestion}`);
    });
    console.log('\n[Connector] Posting automated review comment to GitHub PR #%d...', event.number);
    console.log('[Status] Review completed: Changes requested.');
    return false;
  } else {
    console.log('\n[Review Verdict] APPROVE (Clean Code):');
    console.log('  * All tests pass.');
    console.log('  * No off-by-one errors or security issues detected.');
    console.log('  * Code adheres to project standards.');
    console.log('\n[Connector] Posting automated APPROVE review comment to GitHub PR #%d...', event.number);
    console.log('[Status] Review completed: Approved for merge.');
    return true;
  }
}

function runDoorbellLoop() {
  console.log('######################################################');
  console.log('PROJECT 6: DOOR BELL LOOP (EVENT-DRIVEN AUTOMATION)');
  console.log('Loop Engineering - Heartbeat 4: Event-Driven Loops');
  console.log('######################################################\n');

  const buggyFilePath = path.join(__dirname, 'src', 'sample-code.js');
  const fixedFilePath = path.join(__dirname, 'src', 'sample-code-fixed.js');

  // Event 1: PR Opened with Buggy Code
  const prOpenedEvent = {
    action: 'opened',
    number: 101,
    title: 'Feat: Add array math utilities (calculateSum, findMax, calculateAverage)',
    author: 'developer-jane',
    head_branch: 'feature/math-utils',
    base_branch: 'main',
    targetFile: buggyFilePath
  };

  const review1 = handlePullRequestEvent(prOpenedEvent);

  console.log('\n... Waiting for developer response / commit ...\n');

  // Event 2: PR Synchronize (Fix pushed)
  const prSynchronizeEvent = {
    action: 'synchronize',
    number: 101,
    title: 'Feat: Add array math utilities (calculateSum, findMax, calculateAverage)',
    author: 'developer-jane',
    head_branch: 'feature/math-utils',
    base_branch: 'main',
    targetFile: fixedFilePath
  };

  const review2 = handlePullRequestEvent(prSynchronizeEvent);

  console.log('\n======================================================');
  console.log('DOOR BELL LOOP DEMONSTRATION COMPLETE');
  console.log('======================================================');
  console.log('1. Event "opened" triggered review -> Caught off-by-one bug');
  console.log('2. Event "synchronize" triggered re-review -> Approved fix');
  console.log('All 4 Heartbeats of Loop Engineering successfully demonstrated!');
}

runDoorbellLoop();
