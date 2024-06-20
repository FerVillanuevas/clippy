import Clippy from "./ClippyModule";

interface IOptions {
  wide: boolean;
}

export async function open(path: string, options: IOptions): Promise<string> {
  return Clippy.open(path, options.wide || false);
}
