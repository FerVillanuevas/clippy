import { requireNativeViewManager } from 'expo-modules-core';
import * as React from 'react';

import { ClippyViewProps } from './Clippy.types';

const NativeView: React.ComponentType<ClippyViewProps> =
  requireNativeViewManager('Clippy');

export default function ClippyView(props: ClippyViewProps) {
  return <NativeView {...props} />;
}
