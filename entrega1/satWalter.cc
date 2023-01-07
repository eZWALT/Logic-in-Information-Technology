
#include <iostream>
#include <stdlib.h>
#include <algorithm>
#include <vector>
using namespace std;

#define UNDEF -1
#define TRUE 1
#define FALSE 0

uint numVars;
uint numClauses;
vector<vector<int> > clauses;
vector<int> model;
vector<int> modelStack;
uint indexOfNextLitToPropagate;
uint decisionLevel;

//xd
vector<vector<int>> posLiterals;
vector<vector<int>> negLiterals;
vector<double> activitat;

int NumConflictes;
int NumDecisions;
int INC = 1;
int DEC = 2;
int TTU = 1000;


void inici(){
  NumConflictes = NumDecisions = 0;
  posLiterals.resize(numVars+1);
  negLiterals.resize(numVars+1);
  activitat.resize(numVars+1,0);
}

void actualitzarActivitat(){

  for(uint i = 1; i < numVars; ++i){
    activitat[i] /= 2.0;
  }

}

void actualitzaActivitatLiteral(int k){
  vector<int> literals = clauses[k];
  int n = literals.size();

  for(int i = 0; i < n;++i){
    int aux = literals[i];
    if(aux < 0) aux = -aux;
    activitat[aux] += INC;
  }
}

void heuristicaActivitat(int k){
  if(NumConflictes%TTU == 0) actualitzarActivitat();

  actualitzaActivitatLiteral(k);
}

int seguentLiteral(){
  int XD = 0;
  int sss = 0;

  for(uint i = 1; i <= numVars; ++i){
    if(model[i] == UNDEF){
      if(activitat[i] > sss){
        sss = activitat[i];
        XD = i;
      }
    }
  }
  ++NumDecisions;
  return XD;
}


//FUNCIO PER LLEGIR CLAUSULES
void readClauses( ){
  // Skip comments
  char c = cin.get();
  while (c == 'c') {
    while (c != '\n') c = cin.get();
    c = cin.get();
  }
  // Read "cnf numVars numClauses"
  string aux;
  cin >> aux >> numVars >> numClauses;
  clauses.resize(numClauses);
  inici();

  // Read clauses
  for (uint i = 0; i < numClauses; ++i) {
    int lit;
    while (cin >> lit and lit != 0){
     clauses[i].push_back(lit);
         if(lit > 0){
      posLiterals[lit].push_back(i);
      activitat[lit] += INC;
    }
    else{
      negLiterals[-lit].push_back(i);
      activitat[-lit] += INC;
    }
    }
  }

}



//RETORNA EL BOOLEA DEL VALOR LIT DEL MODEL
int currentValueInModel(int lit){
  if (lit >= 0) return model[lit];
  else {
    if (model[-lit] == UNDEF) return UNDEF;
    else return 1 - model[-lit];
  }
}


//POSA A TRUE EL LITERAL INDICAT
void setLiteralToTrue(int lit){
  modelStack.push_back(lit);
  if (lit > 0) model[lit] = TRUE;
  else model[-lit] = FALSE;
}


//indica si la propagacio anterior es bona o no

bool propagateGivesConflict ( ) {
  while ( indexOfNextLitToPropagate < modelStack.size() ) {
        vector<int>* vec;
        int lit = modelStack[indexOfNextLitToPropagate];
        if(lit <= 0) vec = &posLiterals[-lit];
        else vec = &negLiterals[lit];


    ++indexOfNextLitToPropagate;
    for (uint i = 0; i < vec->size(); ++i) {
      bool someLitTrue = false;
      int numUndefs = 0;
      int lastLitUndef = 0;
      int point = (*vec)[i];

      for (uint k = 0; not someLitTrue and k < clauses[point].size(); ++k){
	int val = currentValueInModel(clauses[point][k]);
	if (val == TRUE) someLitTrue = true;
	else if (val == UNDEF){ ++numUndefs; lastLitUndef = clauses[point][k]; }
      }
      if (not someLitTrue and numUndefs == 0){
        ++NumConflictes;
        heuristicaActivitat(point);
        return true;
      } // conflict! all lits false
      else if (not someLitTrue and numUndefs == 1) setLiteralToTrue(lastLitUndef);
    }
  }
  return false;
}


void backtrack(){
  uint i = modelStack.size() -1;
  int lit = 0;
  while (modelStack[i] != 0){ // 0 is the DL mark
    lit = modelStack[i];
    model[abs(lit)] = UNDEF;
    modelStack.pop_back();
    --i;
  }
  // at this point, lit is the last decision
  modelStack.pop_back(); // remove the DL mark
  --decisionLevel;
  indexOfNextLitToPropagate = modelStack.size();
  setLiteralToTrue(-lit);  // reverse last decision
}


// Heuristic for finding the next decision literal:
int getNextDecisionLiteral(){
  for (uint i = 1; i <= numVars; ++i) // stupid heuristic:
    if (model[i] == UNDEF) return i;  // returns first UNDEF var, positively
  return 0; // reurns 0 when all literals are defined
}

void checkmodel(){
  for (uint i = 0; i < numClauses; ++i){
    bool someTrue = false;
    for (uint j = 0; not someTrue and j < clauses[i].size(); ++j)
      someTrue = (currentValueInModel(clauses[i][j]) == TRUE);
    if (not someTrue) {
      cout << "Error in model, clause is not satisfied:";
      for (uint j = 0; j < clauses[i].size(); ++j) cout << clauses[i][j] << " ";
      cout << endl;
      exit(1);
    }
  }
}

int main(){
  readClauses(); // reads numVars, numClauses and clauses
  model.resize(numVars+1,UNDEF);
  indexOfNextLitToPropagate = 0;
  decisionLevel = 0;

  // Take care of initial unit clauses, if any
  for (uint i = 0; i < numClauses; ++i)
    if (clauses[i].size() == 1) {
      int lit = clauses[i][0];
      int val = currentValueInModel(lit);
      if (val == FALSE) {cout << "UNSATISFIABLE" << endl; return 10;}
      else if (val == UNDEF) setLiteralToTrue(lit);
    }

  // DPLL algorithm
  while (true) {
    while ( propagateGivesConflict() ) {
      if ( decisionLevel == 0) { cout << "UNSATISFIABLE" << endl; return 10; }
      backtrack();
    }
    int decisionLit = seguentLiteral();
    if (decisionLit == 0) { checkmodel(); cout << "SATISFIABLE" << endl; return 20; }
    // start new decision level:
    modelStack.push_back(0);  // push mark indicating new DL
    ++indexOfNextLitToPropagate;
    ++decisionLevel;
    setLiteralToTrue(decisionLit);    // now push decisionLit on top of the mark
  }
}
