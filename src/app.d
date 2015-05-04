import std.stdio;
import std.algorithm;
import std.regex;
import std.conv;

void main(string[] args) {
   if (args.length > 1) {
      string poFile = args[1];
      convert(poFile);
   } else {
      writeln("invalid filename");
      writeln("   po2lang x.po");
   }
}

void convert(string poFile) {
   enum state {
      waitID,
      startStr,
      continueStr
   }

   state st = state.waitID;
   auto file = File(poFile);
   string text;
   foreach (line; file.byLine()) {
      final switch (st) with (state) {
         case waitID:
            auto msgidRegExp = regex(`^msgid\s*"([^"]+)"`);
            auto m = match(line, msgidRegExp);
            if (!m.empty) {
               writef(`"%s"`, m.captures[1]);
               st = startStr;
            }
            break;
         case startStr:
            auto msgstrRegExp = regex(`^msgstr\s*"([^"]+)"`);
            auto m = matchFirst(line, msgstrRegExp);
            text = m[1].to!string();
            st = state.continueStr;
            break;
         case continueStr:
            auto strRegExp = regex(`^\s*"([^"]+)"`);
            auto m = matchFirst(line, strRegExp);
            if (!m.empty) {
               text ~= m[1].to!string();
            } else {
               writefln(`="%s"`, text);
               st = state.waitID;
            }
      }
   }
}
