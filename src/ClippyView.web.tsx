import * as React from 'react';

import { ClippyViewProps } from './Clippy.types';

export default function ClippyView(props: ClippyViewProps) {
  return (
    <div>
      <span>{props.name}</span>
    </div>
  );
}
