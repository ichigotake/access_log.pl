requires 'perl', '5.008001';

on 'test' => sub {
  requires 'local::lib';
  requires 'Path::Tiny';
  requires 'Pod::Markdown';
  requires 'Text::Diff';
};
