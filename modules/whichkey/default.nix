{
  plugins.which-key = {
    enable = true;
    settings = {
      spec = [
        #                           csc textit
        # \textbf{Make me italic!}     -->      \textit{Make me italic!}
        { __unkeyed = "csc"; desc = "VimTex: (C)hange (S)urrounding (C)ommand"; }
        # cs$ + enumeration
        # $ 1+1 => \begin{enumeration} 1+1 \end{enumeration}
        { __unkeyed = "cs$"; desc = "VimTex: (C)hange (S)urrounding (math => $) (E)nvironment"; }

        # surround-typa commants
        #       \begin{quote}                 dse
        #       Using VimTeX is lots of fun!  -->  Using VimTeX is lots of fun!
        #       \end{quote}
        { __unkeyed = "dse"; desc = "VimTex: (D)elete (S)urrounding LaTeX (E)nvironment"; }

        # \begin{equation*}   cse align   \begin{align*}
        # % contents         -->          % contents
        # \end{equation*}                 \end{align*}
        { __unkeyed = "cse"; desc = "VimTex: (C)hange (S)urrounding LaTeX (E)nvironment"; }

        # \textit{Hello, dsc!}  -->  Hello, dsc!
        { __unkeyed = "dsc"; desc = "VimTex: (D)elete (S)urrounding LaTeX (C)ommand"; }

        #                     dsd               |               dsd[
        # \left(X + Y\right)  -->  X + Y        |     (x + y)  ------>  x + y
        { __unkeyed = "dsd"; desc = "VimTex: (D)elete the (S)urrounding (D)elimetrs"; }

        #                  csd [
        # (a + b)   -->   [b + b]
        { __unkeyed = "csd"; desc = "VimTex: (D)elete the (S)urrounding LaTeX (D)elimeters"; }

        #                 ds$
        # $ 1 + 1 = 2 $   -->  1 + 1 = 2
        { __unkeyed = "ds$"; desc = "VimTex: (D)elete the (S)urrounding (math => $)"; }

        #                     tsc                       tsc
        # \section{Toggling}  -->  \section*{Toggling}  -->  \section{Toggling}
        # -----------------------------------------------------------------------
        # \begin{equation}   tss   \begin{equation*}   tss   \begin{equation}
        #     x + y = z      -->        x + y = z      -->       x + y = z
        # \end{equation}           \end{equation*}           \end{equation}
        { __unkeyed = "die"; desc = "VimTex: (D)elete (whats) (I)nside LaTeX (E)nvironment"; }


        { __unkeyed = "die"; desc = "VimTex: (D)elete (whats) (I)nside LaTeX (E)nvironment"; }
        { __unkeyed = "vie"; desc = "VimTex: (V)isually select (I)nside (E)nvironment"; }

        # TODO add all the Vimtex commands, for example aP and ac typa commands aren't included yet

        {
          __unkeyed-1 = "<leader>b";
          group = "buffers";
        }
      ];
    };
  };
}
