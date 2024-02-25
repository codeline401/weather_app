# flutter_weather

A new Flutter project.

## Getting Started

Our app should let users

    Search for a city on a dedicated search page
    See a pleasant depiction of the weather data returned by Open Meteo API
    Change the units displayed (metric vs imperial)

Key Concepts

    Observe state changes with BlocObserver
    BlocProvider, Flutter widget that provides a bloc to its children
    BlocBuilder, Flutter widget that handles building the widget in response to new states
    Prevent unnecessary rebuilds with Equatable
    RepositoryProvider, a Flutter widget that provides a repository to its children
    BlocListener, a Flutter widget that invokes the listener code in response to state changes in the bloc
    MultiBlocProvider, a Flutter widget that merges multiple BlocProvider widgets into one
    BlocConsumer, a Flutter widget that exposes a builder and listener in order to react to new states
    HydratedBloc to manage and persist state