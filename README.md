## one_logger
`one_logger` is a simple yet powerful logging package that outputs logs in a single line format `[date level module msg]`. With ANSI support, it enhances the readability of logs in your console.

### Features
- **Single line logging**: Each log is output in a single line, with a timestamp, log level, module, and message.
- **ANSI support**: Logs are colored based on their log level, making them easier to distinguish in the console.
- **Customizable**: Various options allow you to customize the logging behavior to suit your needs.
- **[Loki Support](https://grafana.com/oss/loki/)**: Push logs to Loki.

### Usage
First, create a `Logger` instance:

```dart
const logger = Logger();
```
```dart
const logger = Logger(
    service: "your_service_name",
    defaultModule: "default_module_name",
    lokiOptions: LokiOptions(lokiUrl: "your_loki_url"),
    options: LoggerOptions(),
    filter: DevelopmentLoggerFilter(),
);
```
If Loki is configured, call `startLoki()` before using the logger:

```dart
logger.startLoki();
```
And make sure to call `disposeLoki()` when you're done with the logger:

```dart
logger.disposeLoki();
```

You can then log messages using the `Logger` methods:

```dart
logger.trace("This is a trace log");
logger.info("This is an info log");
logger.warn("This is a warn log");
logger.error("This is an error log");
logger.debug("This is a debug log");
```

### Classes
- `LokiOptions`: Configuration options for Loki, a horizontally-scalable, highly-available, multi-tenant log aggregation system.

- `LoggerOptions`: Options for configuring the logger, including styles for each log level and whether to enable ANSI.

- `LoggerFilter`: Abstract class representing a filter that determines whether a log of a particular level should be printed or pushed.

- `DevelopmentLoggerFilter`: Logger filter suitable for development environments.

- `ProductionLoggerFilter`: Logger filter suitable for production environments.

- `Logger`: The main logger class. Provides methods for logging messages of different levels.

- `ansiPrint`: Function to print a log with ANSI color codes.

### Customization
You can customize the logger's behavior by providing your own `LoggerOptions` and `LoggerFilter` when creating the `Logger`. This allows you to control aspects such as the colors of the logs, whether to enable ANSI, and which logs should be printed or pushed.