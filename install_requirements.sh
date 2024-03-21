# 选择使用的系统包管理器并判断是否具有root权限， 如果没有root权限，询问密码
HAS_APT_GET=$(ls /usr/bin | grep apt-get)
HAS_PACMAN=$(ls /usr/bin | grep pacman)
if [ "$(id -u)" -eq 0 ]; then
  if [ -n "$HAS_APT_GET" ]; then
    echo "Use apt-get as package manager"
    PACKAGE_MAN_CMDLINE="apt-get install -y"
  elif [ -n "$HAS_PACMAN" ]; then
    echo "Use pacman as package manager"
    PACKAGE_MAN_CMDLINE="pacman -S --noconfirm"
  fi
else
  echo -n "请输入密码: ";read -sr PASSWORD;echo ""
  if [ -n "$HAS_APT_GET" ]; then
    echo "Use apt-get as package manager"
    PACKAGE_MAN_CMDLINE="echo '$PASSWORD' | sudo -S apt-get install -y"
  elif [ -n "$HAS_PACMAN" ]; then
    echo "Use pacman as package manager"
    PACKAGE_MAN_CMDLINE="echo '$PASSWORD' | sudo -S pacman -S --noconfirm"
  fi
fi

# 根据不同的包管理器设置安装的库名称
if [ -n "$HAS_APT_GET" ]; then
  LIB_TURBO_JPEG="libturbojpeg"
  NINJA_BUILD="ninja-build"
elif [ -n "$HAS_PACMAN" ]; then
  LIB_TURBO_JPEG="libjpeg-turbo"
  NINJA_BUILD="ninja"
fi

# 安装git库的函数，方便使用系统设置的proxy加速
pip_with_git() {
  TEMP_DIR=$(mktemp -d)
  if [ -n "$TEMP_DIR" ]; then
    pushd "$TEMP_DIR" || return 255
    git clone $1 "$TEMP_DIR" || return 255
    pip install . || return 255
    popd || return 255
    rm -rf "$TEMP_DIR"
  else
    echo "Cannot create temp dir"
    return 255
  fi
}

echo "****************** Installing pytorch ******************"
conda install -y pytorch==1.7.0 torchvision==0.8.1 cudatoolkit=10.2 -c pytorch

echo ""
echo ""
echo "****************** Installing yaml ******************"
pip install PyYAML

echo ""
echo ""
echo "****************** Installing easydict ******************"
pip install easydict

echo ""
echo ""
echo "****************** Installing cython ******************"
pip install cython

echo ""
echo ""
echo "****************** Installing opencv-python ******************"
pip install opencv-python

echo ""
echo ""
echo "****************** Installing pandas ******************"
pip install pandas

echo ""
echo ""
echo "****************** Installing tqdm ******************"
conda install -y tqdm

echo ""
echo ""
echo "****************** Installing coco toolkit ******************"
pip install pycocotools

echo ""
echo ""
echo "****************** Installing jpeg4py python wrapper ******************"
eval "$PACKAGE_MAN_CMDLINE" "$LIB_TURBO_JPEG"
pip install jpeg4py

echo ""
echo ""
echo "****************** Installing tensorboard ******************"
pip install tb-nightly

echo ""
echo ""
echo "****************** Installing tikzplotlib ******************"
pip install tikzplotlib

echo ""
echo ""
echo "****************** Installing thop tool for FLOPs and Params computing ******************"
pip_with_git https://github.com/Lyken17/pytorch-OpCounter

echo ""
echo ""
echo "****************** Installing colorama ******************"
pip install colorama

echo ""
echo ""
echo "****************** Installing lmdb ******************"
pip install lmdb

echo ""
echo ""
echo "****************** Installing scipy ******************"
pip install scipy

echo ""
echo ""
echo "****************** Installing visdom ******************"
pip install visdom

echo ""
echo ""
echo "****************** Installing vot-toolkit python ******************"
pip_with_git https://github.com/votchallenge/vot-toolkit-python


echo ""
echo ""
echo "****************** Installing timm ******************"
pip install timm==0.4.12

echo "****************** Installing yacs/einops/thop ******************"
pip install yacs
pip install einops
pip install thop

echo "****************** Install ninja-build for Precise ROI pooling ******************"
eval "$PACKAGE_MAN_CMDLINE" "$NINJA_BUILD"

echo "****************** Installation complete! ******************"