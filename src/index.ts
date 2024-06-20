import { NativeModulesProxy, EventEmitter, Subscription } from 'expo-modules-core';

// Import the native module. On web, it will be resolved to Clippy.web.ts
// and on native platforms to Clippy.ts
import ClippyModule from './ClippyModule';
import ClippyView from './ClippyView';
import { ChangeEventPayload, ClippyViewProps } from './Clippy.types';

// Get the native constant value.
export const PI = ClippyModule.PI;

export function hello(): string {
  return ClippyModule.hello();
}

export async function setValueAsync(value: string) {
  return await ClippyModule.setValueAsync(value);
}

const emitter = new EventEmitter(ClippyModule ?? NativeModulesProxy.Clippy);

export function addChangeListener(listener: (event: ChangeEventPayload) => void): Subscription {
  return emitter.addListener<ChangeEventPayload>('onChange', listener);
}

export { ClippyView, ClippyViewProps, ChangeEventPayload };
