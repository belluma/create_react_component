#!/bin/bash

arguments=("$@")
typescript=1
story=1
test=1


#get options
for((i=0;i<${#arguments[@]};i++));do
    arg=${arguments[i]}
    if [ $arg = "--no-typescript" ]
    then
        typescript=0;
    fi
    
    if [ $arg = "--no-story" ]
    then
        story=0
    fi
    if [ $arg = "--no-test" ]
    then
        test=0
    fi
    if [ $arg = "--css" ]
    then
        css=1
    fi
done



react_component(){
    
    [[ $typescript = 1 ]] && extension=.tsx || extension=.jsx
    componentFolder=$1/$2
    mkdir -p $componentFolder
    filename=$componentFolder/$2$extension
    touch $filename
    echo "import React from \"react\"
type Props = {};

function $2(props: Props){
    return(
        <div>$2</div>
    )
}

export default $2;" >> $filename
}

story(){
    
    filename=$componentFolder/$2.stories$extension
    touch $filename
    echo "import React from 'react';
import { ComponentStory, ComponentMeta } from '@storybook/react';

import $2 from './$2';

export default {
    title: 'Example/$2',
    component: $2,
    argTypes: {},
} as ComponentMeta<typeof $2>;

const Template: ComponentStory<typeof $2> = (args) => <$2 {...args} />;

export const  Primary = Template.bind({});
    Primary.args = {};" >> $filename
    
}

testFile(){
    
    filename=$componentFolder/$2.test$extension
    touch $filename
    
    echo "import React from 'react';
import ReactDOM from 'react-dom';
import $2 from './$2';

it('renders without crashing', () => {
  const div = document.createElement('div');
  ReactDOM.render(<$2 />, div);
    });" >> $filename
    
}

stylesheet(){
    [[ $css = 1 ]] && extension=.css || extension=.scss
    filename=$componentFolder/$2.module$extension
    touch $filename
    echo ".$2 {
    }" >> $filename
}


build_files(){
    react_component $1 $2
    story $1 $2
    testFile $1 $2
    stylesheet $1 $2
}


build_files $1 $2

for ((i = 0 ; i < ${#arguments[@]} ; i++)) ;do
    if [[ i -gt 0 && ${arguments[$i]:0:1} != - ]];then
        build_files $1 ${arguments[$i]}
    fi
done
