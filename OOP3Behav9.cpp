#include "pt4.h"
using namespace std;

class OperationA
{
public:
    static void ActionA();
    static void UndoActionA();
};

void OperationA::ActionA()
{
    pt << "+A";
}
void OperationA::UndoActionA()
{
    pt << "-A";
}

class OperationB
{
public:
    static void ActionB();
    static void UndoActionB();
};

void OperationB::ActionB()
{
    pt << "+B";
}
void OperationB::UndoActionB()
{
    pt << "-B";
}

class OperationC
{
public:
    static void ActionC();
    static void UndoActionC();
};

void OperationC::ActionC()
{
    pt << "+C";
}
void OperationC::UndoActionC()
{
    pt << "-C";
}

class Command
{
public:
    virtual void Execute() = 0;
    virtual void Unexecute() = 0;
};
class CommandA :public Command {
public:
    void Execute() { OperationA a; a.ActionA(); }
    void Unexecute() { OperationA a; a.UndoActionA(); }
};
class CommandB :public Command {
public:
    void Execute() { OperationB b; b.ActionB(); }
    void Unexecute() { OperationB b; b.UndoActionB(); }
};
class CommandC :public Command {
public:
    void Execute() { OperationC c; c.ActionC(); }
    void Unexecute() { OperationC c; c.UndoActionC(); }
};
class MacroCommand :public Command {
    vector<Command*>cmds;
public:
    MacroCommand(Command* cmd1, Command* cmd2) { cmds.push_back(cmd1); cmds.push_back(cmd2); };
    void Execute() {
        for (int i = 0; i < cmds.size(); i++) { cmds[i]->Execute(); }
    }
    void Unexecute() { for (int i = cmds.size()-1; i >=0; i--) { cmds[i]->Unexecute(); } }
};
// Implement the CommandA, CommandB, CommandC
//   and MacroCommand descendant classes

class Menu
{
    vector<Command*>availcmds;
    vector<Command*>lastcmds;
    int undoIndex;
    // Add required fields
public:
    Menu(Command* cmd1, Command* cmd2);
    void Invoke(int cmdIndex);
    void Undo(int count);
    void Redo(int count);
};

Menu::Menu(Command* cmd1, Command* cmd2)
{
    Command* a = cmd1;
    Command* b = cmd2;
    MacroCommand* c = new MacroCommand(a, b);
    availcmds.push_back(a);
    availcmds.push_back(b);
    availcmds.push_back(c);
    undoIndex = -1;
    // Implement the constructor
}
void Menu::Invoke(int cmdIndex)
{
    availcmds[cmdIndex]->Execute();
    auto i = lastcmds.begin();
    advance(i, undoIndex+1);
    lastcmds.erase(i,lastcmds.end());
    lastcmds.push_back(availcmds[cmdIndex]);
    undoIndex = lastcmds.size() - 1;
    Show(undoIndex);
}
void Menu::Undo(int count)
{
    int x = count;
    int i = undoIndex;
    for (; i >= 0&&x>0; i--)
    {
        lastcmds[i]->Unexecute();
        x--;
    }
    undoIndex = i;
}
void Menu::Redo(int count)
{
    int x = count;
    int i = undoIndex+1;
    for ( ;i < lastcmds.size()&&x>0; i++)
    {
        lastcmds[i]->Execute();
        x--;
    }
    undoIndex = i-1;
}

void Solve()
{
    Task("OOP3Behav9");
    char c1;
    char c2;
    int n;
    pt >> c1 >> c2;
    Command* p1;
    Command* p2;
    if (c1 == 'A')
        p1 = new CommandA;
    else if (c1 == 'B')
        p1 = new CommandB;
    else
        p1 = new CommandC;
    if (c2 == 'A')
        p2 = new CommandA;
    else if (c2 == 'B')
        p2 = new CommandB;
    else
        p2 = new CommandC;
    Menu* m = new Menu(p1, p2);
    pt >> n;
    for (int i = 0; i < n; i++)
    {
        string s;
        pt >> s;
        if (s[0] == 'I')
            m->Invoke(s[1] - '0');
        else if (s[0] == 'U')
            m->Undo(s[1] - '0');
        else
            m->Redo(s[1] - '0');
    }
}
