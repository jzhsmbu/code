#include "pt4.h"
using namespace std;
class Context
{
    string names[10];
    int data[10];
public:
    Context() {
        for (int i = 0; i < 10; i++)
        {
            names[i] = 'a' + i;
            data[i] = 0;
        }
    }
    void SetVar(int ind, string name, int value)
    {
        names[ind] = name;
        data[ind] = value;
    }
    string GetName(int ind) { return names[ind];}
    int GetValue(int ind) { return data[ind]; }
};

class AbstractExpression
{
public:
    virtual string InterpretA(Context* cont) = 0;
    virtual string InterpretB(Context* cont) = 0;
};

// Implement the TermStr, NontermConcat, NontermIfq
//   and NontermLoop descendant classes
class NontermConcat :public AbstractExpression
{
    vector< AbstractExpression*> exprs;
public:
    NontermConcat(vector< AbstractExpression*>& V) :exprs(V) {}
    string InterpretA(Context* cont) override
    {
        string s = "";
        //for (auto p = exprs.begin(); p != exprs.end(); p++)
        //{
        //    //Show((*p)->InterpretA(cont));
        //    //Show(1);
        //}
            
        for (auto e : exprs)
            s += e->InterpretA(cont);
        return s;
    }
    string InterpretB(Context* cont) override
    {
        string s = "";
        for (auto e : exprs)
            s += e->InterpretB(cont);
        return s;
    }
};
class NontermIf :public AbstractExpression
{
    AbstractExpression* expr1,* expr2;
    int ind;
public:
    NontermIf(AbstractExpression* expr1, AbstractExpression* expr2, int ind) :expr1(expr1), expr2(expr2), ind(ind) {}
    string InterpretA(Context* cont) override
    {
        return "(" + cont->GetName(ind) + "?" + expr1->InterpretA(cont) +":"+ expr2->InterpretA(cont) + ")";
    }
    string InterpretB(Context* cont) override
    {
        if (cont->GetValue(ind) != 0)
            return expr1->InterpretB(cont);
        else return expr2->InterpretB(cont);
    }
};
class NontermLoop :public AbstractExpression
{
    AbstractExpression* expr;
    int ind;
public:
    NontermLoop(AbstractExpression* expr,int ind):expr(expr),ind(ind){}
    string InterpretA(Context* cont) override
    {
        return "(" + cont->GetName(ind) + ":"+expr->InterpretA(cont) + ")";
    }
    string InterpretB(Context* cont) override
    {
        if (cont->GetValue(ind) > 0)
        {
            string s;
            for (int i = 0; i < cont->GetValue(ind); i++)
                s = s + expr->InterpretB(cont);
            return s;
        }
        else return "";
    }
};
class TermStr :public AbstractExpression
{
    string s;
public:
    TermStr(string s) :s(s) {}
    string InterpretA(Context* cont) override { return s; }
    string InterpretB(Context* cont) override { return s; }
};
void Solve()
{
    Task("OOP3Behav17");
    int N;
    pt >> N;
    vector<AbstractExpression*> V;
    for (int i = 0; i < N; i++)
    {
        char c;
        pt >> c;
        if (c == 'C')
        {
            int K; pt >> K; 
            vector<AbstractExpression*> expr;
            for (int i = 0; i < K; i++)
            {
                int n; pt >> n;
                expr.push_back(V[n]);// Show(K);
            }
            //Show(expr.size());
            AbstractExpression* t = new NontermConcat(expr);
            V.push_back(t);
        }
        if (c == 'I')
        {
            int n; pt >> n;// var[n];
            int n1, n2;
            pt >> n1 >> n2;
            AbstractExpression* t = new NontermIf(V[n1],V[n2],n);
            V.push_back(t);
            //V[n1], V[n2];
        }
        if (c == 'L')
        {
            int n; pt >> n;// var[n];
            int n1; pt >> n1; //V[n1];
            AbstractExpression* t = new NontermLoop(V[n1], n);
            V.push_back(t);
        }
        if (c == 'S')
        {
            string str; pt >> str;
            AbstractExpression* ae = new TermStr(str);
            V.push_back(ae);
        }
    }
    for (int i = 0; i < 3; i++)
    {
        int M;
        pt >> M;
        //AbstractExpression* ae = new NontermConcat(V);
        //string s1, s2;
        Context* ct = new Context();
        for (int j = 0; j < M; j++)
        {
            int ind, val;
            string name;
            pt >> ind >> name >> val;  
            ct->SetVar(ind, name, val);
        }
        //Show(V[5]->InterpretA(ct));
        //Show(V[5]->InterpretB(ct));
        pt<<V[V.size() - 1]->InterpretA(ct);
        pt<<V[V.size() - 1]->InterpretB(ct);
       // pt << s1 << s2;
    }

}
