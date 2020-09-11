use v6;

unit class MIME::Types;

has %.exts;
has %.types;

method new (Str() $mtfile = %?RESOURCES<mime.types>) {
  if $mtfile.IO !~~ :f {
    die "Invalid mime.types file: $mtfile";
  }
  my @lines = slurp($mtfile).lines;
  my $types = {};
  my $exts  = {};
  for @lines -> $line {
    if $line eq '' || $line ~~ /^'#'/ { next; }
    my ($ctype, @exts) = $line.split(/\s+/);
    #$*ERR.say: "# Found: $ctype, {@exts.perl}";
    $types{$ctype} = @exts;
    for @exts -> $ext {
      $exts{$ext} = $ctype;
    }
  }
  self.bless(:$exts, :$types);
}

method type ($ext) {
  if %.exts{$ext}:exists {
    return %.exts{$ext};
  }
  return;
}

method extensions ($type) {
  if %.types{$type}:exists {
    #$*ERR.say: "Typedef: "~%.types{$type}.perl;
    return @(%.types{$type});
  }
  return;
}

