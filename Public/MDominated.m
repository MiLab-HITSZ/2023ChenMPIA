function Dominated=MDominated(x,y)
Dominated = (all(x<=y) && any (x<y));
end