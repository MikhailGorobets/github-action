# Read log from the file
TEST_LOG="$(<$GITHUB_WORKSPACE/TestOutput.log)"

RES="OK"

# Verify mode
if [[ "$INPUT_MODE" == "d3d11" ]]; then
    MODE_STR="Direct3D11"
elif [[ "$INPUT_MODE" == "d3d12" ]]; then
    MODE_STR="Direct3D12"
elif [[ "$INPUT_MODE" == "d3d11_sw" ]]; then
    MODE_STR="Direct3D11-SW"
elif [[ "$INPUT_MODE" == "d3d12_sw" ]]; then
    MODE_STR="Direct3D12-SW"
elif [[ "$INPUT_MODE" == "gl" ]]; then
    MODE_STR="OpenGL"
elif [[ "$INPUT_MODE" == "vk" ]]; then
    MODE_STR="Vulkan"
fi
MODE_STR="Running tests in $MODE_STR mode"

# Regular expressions only work inside [[ ]]
if [[ "$TEST_LOG" == *"$MODE_STR"* ]]; then
    echo "Verifying '$MODE_STR': OK"
else
    echo "Verifying '$MODE_STR': FAIL"
    RES="FAIL"
fi


#Verify shader compiler
if [[ "$INPUT_USE_DXC" == "true" ]]; then
    COMPILER_STR="DXC"
else
    COMPILER_STR="Default"
fi
COMPILER_STR="Selected shader compiler: $COMPILER_STR"

# Regular expressions only work inside [[ ]]
if [[ "$TEST_LOG" == *"$COMPILER_STR"* ]]; then
    echo "Verifying '$COMPILER_STR': OK"
else
    echo "Verifying '$COMPILER_STR': FAIL"
    RES="FAIL"
fi


if [[ "$INPUT_USE_DXC" == "true" ]]; then
    if [[ "$TEST_LOG" == *"TextureCreation/TextureCreationTest"* ]]; then
        echo "Texture creation tests are not supposed to run when DXC is used"
        RES="FAIL"
    fi
fi


if [[ "$RES" != "OK" ]]; then
    # echo "Captured Test log:"
    # echo "$TEST_LOG"
    exit 1
fi
