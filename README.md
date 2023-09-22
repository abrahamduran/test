## Instructions

The client's Personal Finance Tracker App is in progress and is at a stage where users can currently view the balance of a specific account. The client has expressed the desire to add further functionality to enhance the user experience, and here's a breakdown of their requests:

1. Below the account balance, we would like to see the last ten transactions, including the title and cost (this account will only contain debits, no credits).
2. The account balance and transactions should be saved so that the user can view their balance and transactions even when offline. These values should refresh when a new network connection is available.
3. Implement the new styles that have been provided in a [Figma file](https://www.figma.com/file/gc7NONoPrghg2sVwItLu6f/Formula-Money?type=design&node-id=1%3A2&mode=design&t=jayHJnsOxRog2r49-1).

**Stretch Goals (Optional):**
- **In-App Purchase for Premium Feature:** Implement in-app billing functionality to manage access to our premium tier. We have an API that can take a collection of transactions and display simple budgeting advice for the user.

These requests come directly from the client alongside the initial codebase. The stretch goals are optional but would be highly valuable if achievable within the time frame.

The client has also provided an [API service](https://8kq890lk50.execute-api.us-east-1.amazonaws.com/prd/api) you can use for retrieving transactional data. It's already used for the Balance.

Please review the existing assets and begin working on these features as per the client's requests.

## Status Updates

### Day 1
- Designed the test plan for the app.
- Reviewed the API and got unblocked from the questions about the assessment.
- Reported an error with the API (which appears to only affect Safari/WebKit). **The scope of the assessment is not affected by this**.
- Performed a minor refactor on `MoneyService` to propagate errors.
- Implemented the `transactions` endpoint in MoneyService

### Day 2
- Refactored `AccountViewModel` to expose output properties wrapped in `ViewState`
- Implemented UI changes to display the last ten transactions
- Implemented offline support for account balance and transactions
- Added UI icon to indicate to the user the status of the network connection
- Added unit and UI tests to cover the transaction changes

### Day 3
- Implemented error handling and recovery
- Added unit tests to cover error handling and network conditions

## Test Plan

<details>
<summary>Test Category: Display Account Balance</summary>

- **Fetch Account Balance Successfully**
    - Test that the API call fetches the account balance correctly. ✅
    - Verify that the balance is displayed in the UI. ✅
- **Fetch Account Balance Failure**
    - Simulate an API failure scenario. ✅
    - Test if the app gracefully handles API failures (e.g., by displaying an error message). ✅
- **Offline Account Balance**
    - Test if the app correctly retrieves and displays the last saved account balance when offline. ✅

</details>

<details>
<summary>Test Category: Display Last Ten Transactions</summary>

- **Fetch Last Ten Transactions Successfully**
    - Test that the API call fetches the last 10 transactions correctly. ✅
    - Verify that the transactions are displayed in the UI. ✅
- **Fetch Transactions Failure**
    - Simulate an API failure scenario. ✅
    - Test if the app handles this gracefully (e.g., by displaying an error message). ✅
- **Offline Transactions**
    - Test if the app correctly retrieves and displays the last saved transactions when offline. ✅
- **Empty Transactions List**
    - Test how the app handles an empty transactions list. ✅

</details>

<details>
<summary>Test Category: Offline Support</summary>

- **Save Account Balance Offline**
    - Test if the account balance is saved correctly for offline access. ✅
- **Save Transactions Offline**
    - Test if the last 10 transactions are saved correctly for offline access. ✅
- **Network Reconnection**
    - Test if the app refreshes the data when network connection is restored. ✅
- **Stale Data Indicator**
    - Test if the app correctly displays an indicator for stale data when offline. ✅

</details>

<details>
<summary>Test Category: In-App Purchase (Optional)</summary>

- **In-App Purchase Success**
    - Test successful in-app purchase flow. ⭕️
- **In-App Purchase Failure**
    - Test failure scenarios for in-app purchase. ⭕️
- **Premium Features Accessibility**
    - Test if premium features are accessible only after a successful in-app purchase. ⭕️

</details>

## Assessment Conclusion

### Results
During the timeframe for this assessment, the main functionalities requested by the client were implemented, those are:
- Displaying the last ten transactions below the account balance
- Adding offline support for the account balance and transactions
- Implemented the style provided in the Figma

I was also able to further enhance these functionalities by adding the following:
- A network state indicator, so the user is aware of whether they are viewing the most recent transactions or a locally saved copy (which might be outdated)
- The ability to handle errors and retry in case a network call fails

Finally, we covered all these features with unit and UI tests to safeguard the code and its functionality from breaking. The code coverage reported is 92%.

### Decisions made during the assessment

**UserDefault for offline support**

It’s crucial to consider the sensitivity of the data being stored. For instance, financial transactions are highly sensitive in nature. Therefore, storing such data in UserDefaults is not advisable as it’s not designed for that purpose. However, if the app is intended for a limited number of users, as data is fetched for a hardcoded account, we could get away with that approach. The ideal and future-proof solution would have been Core Data (or SwiftData if iOS 16 support can be dropped).

The critical factor in choosing UserDefaults here is saving development time, as other options could mean more effort. The reasons I found UserDefault to be a capable solution here are:
- The dataset to be stored is simple, with no constraints or relational relationships.
- The dataset is not queryable.
- The user can’t interact with the dataset
- There are no rules to sync the dataset across devices.
- The updating process for the offline data is pretty much “replace with whatever is on the backend”.

**Refactoring `MoneyService` to propagate errors**

Callers should be able to know and react when things go sideways, in this case, when an error from the API occurs. We could have changed the return type to be a `tuple` or a `Result<Success, Failure>`, I just preferred `throw` as it feels more natural with the `async/await` approach.

**Refactoring `AccountViewModel` to use `ViewState`**

Provide an isolated control over states (like loading or error) for `accountBalance` and `transactions` without creating multiple boolean properties (_"Enumerate, Don't Booleanate"_).

### Next Steps
If more time is allocated to this assessment, the next action would be adding support for the Premium Feature through In-App Purchases. This includes API integration, UI changes, integrating the `StoreKit` framework, and covering the functionality with appropriate tests.

Additionally, I suggest allocating some time to enhance UI Testing so that we can alter the app's behavior by injecting some arguments. This could help us test under different scenarios, like forcing an offline state to test the behavior accordingly.

### Screenshots

| Online | Offline | Refreshing | Error |
| ------ | ------- | ---------- | ----- |
| ![online-state][] | ![offline-state][] | ![refreshing-state][] | ![error-state][] |

<!-- screenshot files -->
[online-state]: Screenshots/online-state.png
[offline-state]: Screenshots/offline-state.png
[refreshing-state]: Screenshots/refreshing-state.png
[error-state]: Screenshots/error-state.png