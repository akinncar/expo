export class UnexpectedError extends Error {
  readonly name = 'UnexpectedError';

  constructor(message: string) {
    super(`${message}\nReport this issue: https://github.com/expo/expo/issues`);
  }
}

export type PluginErrorCode =
  | 'INVALID_PLUGIN_TYPE'
  | 'INVALID_PLUGIN_IMPORT'
  | 'PLUGIN_NOT_FOUND'
  | 'CONFLICTING_PROVIDER'
  | 'INVALID_MOD_ORDER'
  | 'MISSING_PROVIDER';

/**
 * Based on `JsonFileError` from `@expo/json-file`
 */
export class PluginError extends Error {
  readonly name = 'PluginError';
  readonly isPluginError = true;

  constructor(
    message: string,
    public code: PluginErrorCode,
    public cause?: Error
  ) {
    super(cause ? `${message}\n└─ Cause: ${cause.name}: ${cause.message}` : message);
  }
}
