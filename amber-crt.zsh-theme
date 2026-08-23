# =================================================================
# AMBER CRT - Oh My Zsh Theme
# Retro terminal aesthetics. 
# Accents: 214 (Amber), 220 (Bright Amber), 172 (Dim Amber)
# =================================================================

# Git configuration (Right Prompt)
ZSH_THEME_GIT_PROMPT_PREFIX="%F{172}BR:[%F{220}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%F{172}]%f"
ZSH_THEME_GIT_PROMPT_DIRTY=" %F{214}[MODIFIED]%f"
ZSH_THEME_GIT_PROMPT_CLEAN=" %F{220}[SYNCED]%f"

# Main Left Prompt: SYS.OP | LOC | █▓▒░
# Uses a blocky fade character setup for the cursor prompt
PROMPT="%F{214}SYS.OP:%F{220}%n %F{214}LOC:%F{220}%~ %F{214}█▓▒░ %f"

# Right Prompt: Git Status & System Time
RPROMPT="\$(git_prompt_info) %F{214}SYS.T:%F{220}%D{%H:%M:%S}%f"