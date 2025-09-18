# Automatic Commitizen + Husky Setup with Branch Append and update comments,commits,branches,pull request on jira.

This guide ensures that **anyone who clones your repo** will have Commitizen + Husky automatically configured, with branch appending enabled.

prerequisite:- branch-name must start with JIRA-ID like PROJ-112-login, your create branch from vscode using atlassian, it automatically create branchname when click start work button on the ticket of jira on vscode.

---

## 1️⃣ Install dependencies

```bash
npm install --save-dev commitizen cz-conventional-changelog husky cz-customizable
```

---

## 2️⃣ Update `package.json` like below

```json
{
  "scripts": {
    "commit": "cz",
    "prepare": "husky install"
  },
  "devDependencies": {
    "commitizen": "^4.3.0",
    "cz-conventional-changelog": "^3.3.0",
    "husky": "^8.0.0"
  },
  "config": {
    "commitizen": {
      "path": "./node_modules/cz-customizable"
    }
  }
}
```

- `"prepare": "husky install"` ensures Husky hooks are installed automatically after `npm install`.

---

## 3️⃣ Configure Commitizen prompts

Create `.cz-config.js`:

```javascript
module.exports = {
  types: [
    { value: 'feat', name: 'feat: A new feature' },
    { value: 'fix', name: 'fix: A bug fix' },
    { value: 'docs', name: 'docs: Documentation only changes' },
    { value: 'refactor', name: 'refactor: Code change that neither fixes a bug nor adds a feature' },
    { value: 'test', name: 'test: Adding tests' }
  ],
  scopes: [],
  allowCustomScopes: false,
  allowBreakingChanges: false,
  skipQuestions: ['scope', 'body', 'breaking', 'issues', 'footer'], // skip issues and footer as well
  messages: {
    type: "Select the type of change:",
    subject: "Write a short, imperative description of the change:"
  },
  subjectLimit: 100,
  breaklineChar: "\n",
  footerPrefix: "Closes: "
};

```

- Only **type** and **description** **scope** prompts appear.  
- Note:- It will ask scope default
---

## 4️⃣ Add Husky commit-msg hook

```bash
npx husky install
#If the error shows like deprecated husky install use below:
npx husky-init && npm install
npx husky add .husky/commit-msg "node scripts/append-branch.js $1"
chmod +x .husky/commit-msg

# remove pre-commit
rm .husky/pre-commit 

git push
```

---

## 5️⃣ Add `append-branch.js` under script

```javascript
const fs = require('fs');
const { execSync } = require('child_process');

const commitMsgPath = process.argv[2];
if (!commitMsgPath) process.exit(1);

// Read the commit message from Commitizen
let msg = fs.readFileSync(commitMsgPath, 'utf8').trim();

// Get branch info
const branchName = execSync('git rev-parse --abbrev-ref HEAD', { encoding: 'utf8' }).trim();

// Extract Jira ID from branch, e.g., RAD-16
const jiraIdMatch = branchName.match(/[A-Z]+-\d+/);
const jiraId = jiraIdMatch ? jiraIdMatch[0] : 'NO-JIRA';

// Compose final commit message
// Assuming Commitizen gives type and short description like "feat(test): Login Design"
const finalMsg = `${jiraId} #comment ${msg} on [${branchName}]`;

// Write it back to commit message file
fs.writeFileSync(commitMsgPath, finalMsg, 'utf8');

console.log(`Formatted commit message: ${finalMsg}`);

```

---

## 6️⃣ Usage for anyone cloning the repo

```bash
git clone <repo>
cd <repo>
npm install   # automatically sets up Husky + Commitizen
npm run commit
```

- Only **type + description** prompts appear  
- Branch and Jira info auto-appended  

---

✅ Now it’s fully **automatic** for any user without extra configuration.

