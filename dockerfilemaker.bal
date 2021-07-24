import ballerina/io;


public function From(int i, string[] dockercontent) returns string{
    string dockerinput = io:readln("Type the image name to import (example: ballerina/ballerina:nightly)\n\n\n");
    dockercontent[i] ="FROM " + dockerinput +"\n";
    return dockercontent[i];
}


public function Workdir(int i, string[] dockercontent) returns string{
    string dockerinput = io:readln("Type a work directory to use in the container (example: /opt/apt)\n\n\n");
    dockercontent[i] ="WORKDIR " + dockerinput +"\n";
    return dockercontent[i];
}

public function Copy(int i, string[] dockercontent) returns string{
    string dockerinput = io:readln("Type the path to a file to copy to the container.\n\n\n");
    dockercontent[i] ="COPY " + dockerinput +" .\n";
    return dockercontent[i];
}


public function Run(int i, string[] dockercontent) returns string{
    string dockerinput = io:readln("Enter a command to run in the container before the container is used.\n\n\n");
    dockercontent[i] = "RUN " +dockerinput;
    string moreruns = io:readln("Want to run any more commands?(y/n)\n\n\n");

    if (moreruns.toLowerAscii() =="y"){
        boolean finished = false;

        while finished == false{ 
            dockerinput = io:readln("Enter another run command.\n\n\n");
            dockercontent[i]+= " && " +dockerinput;
            moreruns = io:readln("any more commands?(y/n)\n\n\n");
            if(moreruns.toLowerAscii() =="n"){finished = true; dockercontent[i]+="\n";}
        }

     }

    return dockercontent[i];
}

public function CMD(int i, string[] dockercontent) returns string{
    string dockerinput = io:readln("Enter a fragment of a command to run when the container is ready. This is because of how Docker processes CMDs." +
    "\nFor example:'java' '-jar' 'jarfile.jar' would be three fragments.\n\n\n");
    string quote ="\u{0022}";
    dockercontent[i] = "CMD [" + quote + dockerinput + quote;
    boolean finished = false;

    while (!finished){
        string moreinput = io:readln("Any more commands?(y/n)\n\n\n");
        if(moreinput.toLowerAscii()=="y"){
            dockerinput = io:readln("Enter a command to append\n\n\n");
            dockercontent[i] += ", " +quote +dockerinput +quote;
        }

        else{
            dockercontent[i]+= "]";
            finished = true;
        }

    }

    return dockercontent[i];
}


public function main() {
    string[] dockercontent = [];
    int i = 0;
 
    dockercontent[i] = From(i, dockercontent);
    i+=1;
    dockercontent[i] = Workdir(i, dockercontent);
    i+=1;
    dockercontent[i] = Copy(i, dockercontent);
    string copymore = io:readln("Any other files to copy?(y/n)");
    if(copymore.toLowerAscii()=="y"){i+=1; dockercontent[i] = Copy(i, dockercontent);}
    i+=1;
    string run = io:readln("Do you want to enter a command for the container to run before the user is ready? (y/n)\n\n\n");
    if (run.toLowerAscii() == "y"){dockercontent[i] = Run(i, dockercontent); i+=1;}
    dockercontent[i] = CMD(i, dockercontent);
    
    io:Error? result = io:fileWriteLines("Dockerfile", dockercontent);
}