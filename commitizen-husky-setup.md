# Automatic Commitizen + Husky Setup with Branch Append

This guide ensures that **anyone who clones your repo** will have Commitizen + Husky automatically configured, with branch appending enabled.

---

## 1️⃣ Install dependencies

```bash
npm install --save-dev commitizen cz-conventional-changelog husky
```

---

## 2️⃣ Update `package.json`

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
      "path": "cz-conventional-changelog"
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
  skipQuestions: ['scope', 'body', 'breaking', 'issues', 'footer'],
  messages: {
    type: "Select the type of change:",
    subject: "Write a short, imperative description of the change:"
  },
  subjectLimit: 100
};
```

- Only **type** and **description** prompts appear.  

---

## 4️⃣ Add Husky commit-msg hook

```bash
npx husky install
npx husky add .husky/commit-msg "node scripts/append-branch.js $1"
chmod +x .husky/commit-msg
```

---

## 5️⃣ Add `append-branch.js` script

```javascript
const fs = require('fs');
const { execSync } = require('child_process');

const commitMsgPath = process.argv[2];
if (!commitMsgPath) process.exit(1);

let msg = fs.readFileSync(commitMsgPath, 'utf8').trim();
const branchName = execSync('git rev-parse --abbrev-ref HEAD', { encoding: 'utf8' }).trim();
const jiraIdMatch = branchName.match(/[A-Z]+-\d+/);
const jiraId = jiraIdMatch ? jiraIdMatch[0] : 'NO-JIRA';
const branchTag = `[${branchName}]`;

// Compose final message
const finalMsg = `${jiraId} #comment ${msg} on ${branchTag}`;
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
