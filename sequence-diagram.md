# Maya Test App - Sequence Diagram

This sequence diagram illustrates the key interactions and flow in the Maya Test App Flutter project, showing the authentication, wallet management, and money transfer features.

```mermaid
sequenceDiagram
    participant User
    participant Main
    participant InitApp
    participant App
    participant AuthCubit
    participant WalletCubit
    participant SendMoneyCubit
    participant AuthRepository
    participant WalletRepository
    participant SendMoneyRepository
    participant AuthAPI
    participant WalletAPI
    participant SendMoneyAPI
    participant SharedPrefs
    participant DioProvider

    Note over User, DioProvider: Application Startup Flow
    User->>Main: Launch App
    Main->>InitApp: runApp(InitApp())
    InitApp->>InitApp: _initializeApp()
    InitApp->>AppConfig: loadConfig()
    InitApp->>InitApp: configureDependencies()
    InitApp->>DioProvider: Initialize Dio with interceptors
    InitApp->>App: Return App widget
    App->>App: MultiBlocProvider setup
    App->>AuthCubit: BlocProvider.create()
    App->>WalletCubit: BlocProvider.create()
    App->>SendMoneyCubit: BlocProvider.create()
    App->>User: Show LoginPage (initial route)

    Note over User, DioProvider: Authentication Flow
    User->>AuthCubit: login(username, password)
    AuthCubit->>AuthCubit: emit(AuthLoading)
    AuthCubit->>AuthRepository: login()
    AuthRepository->>AuthAPI: login()
    AuthAPI->>DioProvider: HTTP POST /auth/login
    DioProvider-->>AuthAPI: Response with token
    AuthAPI-->>AuthRepository: Auth entity
    AuthRepository-->>AuthCubit: Auth result
    alt Authentication Successful
        AuthCubit->>AuthCubit: emit(AuthAuthenticated)
        AuthCubit->>User: Navigate to WalletPage
    else Authentication Failed
        AuthCubit->>AuthCubit: emit(AuthError)
        AuthCubit->>User: Show error message
    end

    Note over User, DioProvider: Wallet Management Flow
    User->>WalletCubit: loadWalletData()
    WalletCubit->>WalletCubit: emit(WalletLoading)
    WalletCubit->>WalletRepository: getBalance()
    WalletRepository->>WalletAPI: getBalance()
    WalletAPI->>DioProvider: HTTP GET /wallet/balance
    DioProvider-->>WalletAPI: Balance response
    WalletAPI-->>WalletRepository: Balance entity
    WalletRepository-->>WalletCubit: Balance data
    
    WalletCubit->>WalletRepository: getTransactions()
    WalletRepository->>WalletAPI: getTransactions()
    WalletAPI->>DioProvider: HTTP GET /wallet/transactions
    DioProvider-->>WalletAPI: Transactions response
    WalletAPI-->>WalletRepository: Transaction list
    WalletRepository-->>WalletCubit: Transactions data
    
    WalletCubit->>WalletCubit: emit(WalletLoaded)
    WalletCubit->>User: Display wallet data

    Note over User, DioProvider: Send Money Flow
    User->>SendMoneyCubit: sendMoney(amount)
    SendMoneyCubit->>SendMoneyCubit: emit(SendMoneyLoading)
    SendMoneyCubit->>SharedPrefs: getValue(mockErrorSendMoney)
    SharedPrefs-->>SendMoneyCubit: Mock error setting
    
    alt Mock Error Enabled
        SendMoneyCubit->>SendMoneyCubit: emit(SendMoneyError)
        SendMoneyCubit->>User: Show error message
    else Normal Flow
        SendMoneyCubit->>SendMoneyRepository: sendMoney(amount)
        SendMoneyRepository->>SendMoneyAPI: sendMoney(amount)
        SendMoneyAPI->>DioProvider: HTTP POST /send-money
        DioProvider-->>SendMoneyAPI: Transaction response
        SendMoneyAPI-->>SendMoneyRepository: Transaction entity
        SendMoneyRepository-->>SendMoneyCubit: Transaction result
        SendMoneyCubit->>SendMoneyCubit: emit(SendMoneySuccess)
        SendMoneyCubit->>User: Show success animation
        
        Note over User, DioProvider: Update Wallet After Send Money
        SendMoneyCubit->>WalletCubit: deductBalance(amount)
        WalletCubit->>WalletRepository: deductBalance(amount)
        WalletRepository->>WalletAPI: deductBalance(amount)
        WalletAPI->>DioProvider: HTTP POST /wallet/deduct
        DioProvider-->>WalletAPI: Updated balance
        WalletAPI-->>WalletRepository: New balance
        WalletRepository-->>WalletCubit: Updated balance
        WalletCubit->>WalletCubit: emit(WalletLoaded)
        WalletCubit->>User: Update wallet display
    end

    Note over User, DioProvider: Logout Flow
    User->>AuthCubit: logout()
    AuthCubit->>AuthCubit: emit(AuthLoading)
    AuthCubit->>AuthRepository: logout()
    AuthRepository->>AuthAPI: logout()
    AuthAPI->>DioProvider: HTTP POST /auth/logout
    DioProvider-->>AuthAPI: Logout response
    AuthAPI-->>AuthRepository: Logout result
    AuthRepository-->>AuthCubit: Logout complete
    AuthCubit->>AuthCubit: emit(AuthInitial)
    AuthCubit->>User: Navigate to LoginPage

    Note over User, DioProvider: Error Handling
    Note over DioProvider: Dio interceptors handle:
    Note over DioProvider: - Logging (DioLoggingInterceptor)
    Note over DioProvider: - Error handling (DioErrorInterceptor)
    Note over DioProvider: - API exceptions (ApiExceptions)
```

## Key Components and Interactions

### 1. **Application Architecture**
- **Clean Architecture** with clear separation of concerns
- **BLoC Pattern** for state management
- **Dependency Injection** using GetIt and Injectable
- **Repository Pattern** for data access

### 2. **Core Features**
- **Authentication**: Login/logout with token management
- **Wallet Management**: Balance tracking and transaction history
- **Money Transfer**: Send money with mock failure testing
- **Error Handling**: Comprehensive error handling with interceptors

### 3. **Data Flow**
- **Presentation Layer**: Cubits manage UI state
- **Domain Layer**: Entities and repositories define business logic
- **Data Layer**: APIs and contracts handle external communication
- **Core Layer**: Dio provider, storage, and utilities

### 4. **Key Interactions**
- App initialization with dependency injection
- Authentication flow with token management
- Wallet data loading and balance updates
- Money transfer with mock error simulation
- Error handling through Dio interceptors

This sequence diagram shows how the different components interact to provide a complete mobile banking experience with proper error handling and state management. 