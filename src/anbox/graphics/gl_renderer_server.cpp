/*
 * Copyright (C) 2016 Simon Fels <morphis@gravedo.de>
 *
 * This program is free software: you can redistribute it and/or modify it
 * under the terms of the GNU General Public License version 3, as published
 * by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranties of
 * MERCHANTABILITY, SATISFACTORY QUALITY, or FITNESS FOR A PARTICULAR
 * PURPOSE.  See the GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 */

#include "anbox/graphics/gl_renderer_server.h"
#include "anbox/graphics/emugl/RenderApi.h"
#include "anbox/graphics/emugl/RenderControl.h"
#include "anbox/graphics/emugl/Renderer.h"
#include "anbox/graphics/layer_composer.h"
#include "anbox/graphics/multi_window_composer_strategy.h"
#include "anbox/graphics/single_window_composer_strategy.h"
#include "anbox/logger.h"
#include "anbox/wm/manager.h"

#include <boost/throw_exception.hpp>
#include <boost/filesystem.hpp>
#include <cstdarg>
#include <stdexcept>

namespace fs = boost::filesystem;

namespace {
void logger_write(const char *format, ...) {

  char message[2048];
  va_list args;

  va_start(args, format);
  vsnprintf(message, sizeof(message) - 1, format, args);
  va_end(args);

  WARNING("%s", message);
}
}

namespace anbox {
namespace graphics {
GLRendererServer::GLRendererServer(const Config &config, const std::shared_ptr<wm::Manager> &wm)
    : renderer_(std::make_shared<::Renderer>()) {

  std::shared_ptr<LayerComposer::Strategy> composer_strategy;
  if (config.single_window)
    composer_strategy = std::make_shared<SingleWindowComposerStrategy>(wm);
  else
    composer_strategy = std::make_shared<MultiWindowComposerStrategy>(wm);

  composer_ = std::make_shared<LayerComposer>(renderer_, composer_strategy);

  auto gl_libs = emugl::default_gl_libraries();
  if (config.driver == Config::Driver::Software) {
    auto swiftshader_path = fs::path(utils::get_env_value("SWIFTSHADER_PATH"));
    const auto snap_path = utils::get_env_value("SNAP");
    if (!snap_path.empty())
      swiftshader_path = fs::path(snap_path) / "lib" / "anbox" / "swiftshader";
    if (!fs::exists(swiftshader_path))
      throw std::runtime_error("Software rendering is enabled, but SwiftShader library directory is not found.");

    gl_libs = std::vector<emugl::GLLibrary>{
      {emugl::GLLibrary::Type::EGL, (swiftshader_path / "libEGL.so").string()},
      {emugl::GLLibrary::Type::GLESv1, (swiftshader_path / "libGLES_CM.so").string()},
      {emugl::GLLibrary::Type::GLESv2, (swiftshader_path / "libGLESv2.so").string()},
    };
  }

  if (!emugl::initialize(gl_libs))
    BOOST_THROW_EXCEPTION(std::runtime_error("Failed to initialize OpenGL renderer"));

  renderer_->initialize(0);

  registerRenderer(renderer_);
  registerLayerComposer(composer_);
}

GLRendererServer::~GLRendererServer() { renderer_->finalize(); }
}  // namespace graphics
}  // namespace anbox
