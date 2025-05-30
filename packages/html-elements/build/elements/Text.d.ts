import React from 'react';
import { BlockQuoteProps, QuoteProps, TimeProps } from './Text.types';
import { TextProps } from '../primitives/Text';
import { ViewProps } from '../primitives/View';
export declare function P({ style, ...props }: TextProps): React.JSX.Element;
export declare function B({ style, ...props }: TextProps): React.JSX.Element;
export declare function S({ style, ...props }: TextProps): React.JSX.Element;
export declare function I({ style, ...props }: TextProps): React.JSX.Element;
export declare function Q({ children, cite, style, ...props }: QuoteProps): React.JSX.Element;
export declare function BlockQuote({ style, cite, ...props }: BlockQuoteProps): React.JSX.Element;
export declare function BR({ style, ...props }: TextProps): React.JSX.Element;
export declare function Mark({ style, ...props }: TextProps): React.JSX.Element;
export declare function Code({ style, ...props }: TextProps): React.JSX.Element;
type PreProps = TextProps | ViewProps;
export declare function Pre(props: PreProps): React.JSX.Element;
export declare function Time({ dateTime, ...props }: TimeProps): React.JSX.Element;
export declare const Strong: typeof B;
export declare const Del: typeof S;
export declare const EM: typeof I;
export declare const Span: React.ComponentType<TextProps>;
export {};
//# sourceMappingURL=Text.d.ts.map