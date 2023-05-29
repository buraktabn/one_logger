## 1.0.9

- Updated `README.md`.

## 1.0.8

- Added `bool enableAnsi` to `LoggerOptions`.

## 1.0.7

- Fixed missing `Filter` export.

## 1.0.6

- Dependency updates.

## 1.0.5

- Minor improvements.

## 1.0.4

- Introduced `LoggerFilter`. Now logs can be filtered by `Level`
- Improved batching functionality.

## 1.0.3

- Introduced `service` and `module`
- Added style constructors to `LogStyle` style logs easily. (Made chatGPT do it. lol)

## 1.0.2+3

- Implemented batch logs
- Introduced `LokiOptions` to configure batch settings

## 1.0.2+2

- Fixed a bug

## 1.0.2+1

- Added `level` label to `Logger` methods

## 1.0.2

- Introduced optional `labels` for Grafana Loki

## 1.0.1+2

- Fixed a bug that causes StackOverFlow

## 1.0.1+1

- Loki push retry on fail

## 1.0.1

- Introducing Grafana Loki Log Pusher

## 1.0.0+3

- Added `copyWith` method to `Logger`.

## 1.0.0+2

- Fixed a issue where `StackTrace` prints null when not provided.

## 1.0.0+1

- Added optional `StackTrace` to `Logger.error`.

## 1.0.0

- Initial version.
