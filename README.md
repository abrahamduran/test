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
- Reviewed the API and got unblocked from the questions about the challenge I had.
- Performed a minor refactor on `MoneyService` to propagate errors.
- Implemented the `transactions` endpoint in MoneyService

## Test Plan

<details>
<summary>Test Category: Display Account Balance</summary>

- **Fetch Account Balance Successfully**
    - Test that the API call fetches the account balance correctly.
    - Verify that the balance is displayed in the UI.
- **Fetch Account Balance Failure**
    - Simulate an API failure scenario.
    - Test if the app gracefully handles API failures (e.g., by displaying an error message).
- **Offline Account Balance**
    - Test if the app correctly retrieves and displays the last saved account balance when offline.

</details>

<details>
<summary>Test Category: Display Last Ten Transactions</summary>

- **Fetch Last Ten Transactions Successfully**
    - Test that the API call fetches the last 10 transactions correctly.
    - Verify that the transactions are displayed in the UI.
- **Fetch Transactions Failure**
    - Simulate an API failure scenario.
    - Test if the app handles this gracefully (e.g., by displaying an error message).
- **Offline Transactions**
    - Test if the app correctly retrieves and displays the last saved transactions when offline.
- **Empty Transactions List**
    - Test how the app handles an empty transactions list.

</details>

<details>
<summary>Test Category: Offline Support</summary>

- **Save Account Balance Offline**
    - Test if the account balance is saved correctly for offline access.
- **Save Transactions Offline**
    - Test if the last 10 transactions are saved correctly for offline access.
- **Network Reconnection**
    - Test if the app refreshes the data when network connection is restored.
- **Stale Data Indicator**
    - Test if the app correctly displays an indicator for stale data when offline.

</details>

<details>
<summary>Test Category: In-App Purchase (Optional)</summary>

- **In-App Purchase Success**
    - Test successful in-app purchase flow.
- **In-App Purchase Failure**
    - Test failure scenarios for in-app purchase.
- **Premium Features Accessibility**
    - Test if premium features are accessible only after a successful in-app purchase.

</details>