# Copyright (c) 2024 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ lib, helpers, ... }:

with lib;
with helpers;
with builtins;
let
  mkSnippet = trig: children:
    let
      isSpecAttr = v: attr: spec:
        elem v (attrNames spec) && spec.${v} attr.${v};
      isSpec = attr: spec:
        isAttrs attr && (all (isSpecAttr attr spec) (attrNames attr));
      trigEngineOptsSpec = { max_len = isInt; };
      trigEngines = [ "plain" "pattern" "ecma" "vim" ];
      triggerSpec = {
        trig = isString;
        name = isString;
        desc = isString;
        dscr = isString;
        wordTrig = isBool;
        regTrig = isBool;
        trigEngine = x:
          (isString x && elem x trigEngines) || (isAttrs x && x ? __raw);
        trigEngineOpts = flip isSpec trigEngineOptsSpec;
        docstring = isString;
        docTrig = isString;
        hidden = isBool;
        priority = x: isInt x && x > 0;
        snippetType = x: isString x && (x == "snippet" || x == "autosnippet");
        resolveExpandParams = x: isAttrs x && x ? __raw;
        condition = x: isAttrs x && x ? __raw;
        show_condition = x: isAttrs x && x ? __raw;
      };
    in addErrorContext "while constructing LuaSnip Snippet call"
    (assert assertMsg (isString trig || isSpec trig triggerSpec)
      "first argument is not a valid trigger";
      assert assertMsg (isList children)
        "second argument must be a list of LuaSnip nodes";
      mkRaw "__s(${toLuaObject trig}, ${toLuaObject children})");

  mkS = mkSnippet;

  mkSnippetNode = i: children:
    addErrorContext "while constructing LuaSnip SnippetNode call"
    (assert assertMsg (isInt i || isNull i)
      "first argument must be an integer (index) or null";
      assert assertMsg (isList children)
        "second argument must be a list of LuaSnip nodes";
      mkRaw "__sn(${toLuaObject i}, ${toLuaObject children})");

  # deadnix: skip
  mkSn = mkSnippetNode;

  # deadnix: skip
  mkIndentSnippetNode = i: children: indent:
    addErrorContext "while constructing LuaSnip IndentSnippetNode call"
    (assert assertMsg (isInt i) "first argument must be an integer (index)";
      assert assertMsg (isList children || isAttrs children && children ? __raw)
        "second argument must be a list of LuaSnip nodes";
      assert assertMsg (isString indent) "third argument must be a string";
      mkRaw "__isn(${toLuaObject i}, ${toLuaObject children}, ${
        toLuaObject indent
      })");

  mkDynamic = i: funBody: references:
    addErrorContext "while constructing LuaSnip DynamicNode call" (let
      function = ''
        function(args, parent)
            ${funBody}
        end
      '';
    in assert assertMsg (isInt i) "first argument must be an integer (index)";
    assert assertMsg (isString funBody)
      "second argument must be a string (namely a lua function body)";
    assert assertMsg (isList references && all (v: isInt v) references)
      "third argument must be a list of integers (index references)";
    mkRaw "__d(${toLuaObject i}, ${function}, ${toLuaObject references})");

  mkD = mkDynamic;

  # deadnix: skip
  mkIsn = mkIndentSnippetNode;

  mkText = content:
    addErrorContext "while constructing LuaSnip TextNode call" (assert assertMsg
      (isString content || (isList content && (all (v: isString v) content)))
      "content must be a list of strings";
      mkRaw "__t(${toLuaObject content})");

  mkT = mkText;

  mkInsert = i:
    addErrorContext "while constructing LuaSnip InsertNode call"
    (assert assertMsg (isInt i) "argument must be an integer (index)";
      mkRaw "__i(${toLuaObject i})");

  mkI = mkInsert;

  mkInsertWithText = i: text:
    addErrorContext "while constructing LuaSnip InsertNode call (with text)"
    (assert assertMsg (isInt i) "argument must be an integer (index)";
      assert assertMsg (isString text || islist text && all isString text)
        "argument must be an string or list of strings";
      mkRaw "__i(${toLuaObject i}, ${toLuaObject text})");

  mkIText = mkInsertWithText;

  mkChoice = i: choices:
    addErrorContext "while constructing LuaSnip ChoiceNode call"
    (assert assertMsg (isInt i) "first argument must be an integer (index)";
      assert assertMsg (isList children)
        "second argument must be a list of LuaSnip nodes";
      mkRaw "__c(${toLuaObject i}, ${toLuaObject children})");

  # deadnix: skip
  mkC = mkChoice;

  snippets = {
    nix = [
      (mkS "!license" [
        (mkT "# Copyright (c) ")
        (mkIText 1 "YEAR Author <email>")
        (mkT [ "" "# This file is licensed under the " ])
        (mkI 2)
        (mkT " license")
        (mkT [
          ""
          "# See the LICENSE file in the repository root for more info."
          ""
          "# SPDX-License-Identifier: "
          ""
        ])
        (mkD 3 ''
          return __sn(nil, {
              __i(1, args[1])
          })
        '' [ 2 ])
      ])
    ];
    sh = [
      (mkS "!license" [
        (mkT "# Copyright (c) ")
        (mkIText 1 "YEAR Author <email>")
        (mkT [ "" "# This file is licensed under the " ])
        (mkI 2)
        (mkT " license")
        (mkT [
          ""
          "# See the LICENSE file in the repository root for more info."
          ""
          "# SPDX-License-Identifier: "
          ""
        ])
        (mkD 3 ''
          return __sn(nil, {
              __i(1, args[1])
          })
        '' [ 2 ])
      ])
    ];
  };

  mkFiletypeSnippets = filetype: snippets:
    addErrorContext
    "while converting LuaSnip snippets for filetype '${filetype}'"
    (assert assertMsg (isString filetype) "filetype must be a string";
      assert assertMsg (isList snippets) "snippets must be a list";
      "__ls.add_snippets(${toLuaObject filetype}, ${toLuaObject snippets})");

  luasnipCommands = let
    # TODO: This is backported from nixpkgs-master
    # Use this when the actual function will be backported to 24.11
    concatMapAttrsStringSep = sep: f: attrs:
      concatStringsSep sep (lib.attrValues (lib.mapAttrs f attrs));
  in addErrorContext "while converting LuaSnip snippets"
  (concatMapAttrsStringSep "\n" mkFiletypeSnippets snippets);
in {
  plugins.luasnip = { enable = true; };

  extraConfigLuaPost = ''
    -- LuaSnip snippets registration
    do
        local __ls = require("luasnip")
        local __s = __ls.snippet
        local __sn = __ls.snippet_node
        local __isn = __ls.indent_snippet_node
        local __t = __ls.text_node
        local __i = __ls.insert_node
        local __f = __ls.function_node
        local __c = __ls.choice_node
        local __d = __ls.dynamic_node
        local __r = __ls.restore_node
        local __events = require("luasnip.util.events")
        local __ai = require("luasnip.nodes.absolute_indexer")
        local __extras = require("luasnip.extras")
        local __l = __extras.lambda
        local __rep = __extras.rep
        local __p = __extras.partial
        local __m = __extras.match
        local __n = __extras.nonempty
        local __dl = __extras.dynamic_lambda
        local __fmt = require("luasnip.extras.fmt").fmt
        local __fmta = require("luasnip.extras.fmt").fmta
        local __conds = require("luasnip.extras.expand_conditions")
        local __postfix = require("luasnip.extras.postfix").postfix
        local __types = require("luasnip.util.types")
        local __parse = require("luasnip.util.parser").parse_snippet
        local __ms = __ls.multi_snippet
        local __k = require("luasnip.nodes.key_indexer").new_key

      -- Creating snippets from config
        ${luasnipCommands}
    end
  '';
}
