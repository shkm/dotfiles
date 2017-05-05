function docker-eval -d "Evals docker machine envs"
  eval (docker-machine env)
end
