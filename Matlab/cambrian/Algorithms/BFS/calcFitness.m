BTS;
N;
plainPL;
std;
Pmin;



PLarray=plainPL(BTS,:);

PL=min(PLarray,[],2);

Pr=tx-PL;

CovProb = 100*(1-0.5*erfc((  Pr  -Pmin)/(std*sqrt(2))));

fitness=min(CovProb);