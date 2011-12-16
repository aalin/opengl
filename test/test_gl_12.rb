#
# Copyright (C) 2007 Jan Dvorak <jan.dvorak@kraxnet.cz>
#
# This program is distributed under the terms of the MIT license.
# See the included MIT-LICENSE file for the terms of this license.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
# OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
# CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
# TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
# SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#

require 'opengl/test_case'

class TestGl12 < OpenGL::TestCase

  def test_glblend
    supported?(1.2)
    glBlendColor(0.0, 1.0, 0.0, 1.0)
    assert_equal(glGetDoublev(GL_BLEND_COLOR), [0, 1, 0, 1])

    glBlendEquation(GL_MIN)
    assert_equal(glGetIntegerv(GL_BLEND_EQUATION), GL_MIN)
    glBlendEquation(GL_MAX)
    assert_equal(glGetIntegerv(GL_BLEND_EQUATION), GL_MAX)
  end

  def test_gldrawrangeelements
    supported?(1.2)
    va = [0, 0, 0, 1, 1, 1].pack("f*")
    glVertexPointer(2, GL_FLOAT, 0, va)

    buf = glFeedbackBuffer(256, GL_3D)
    glRenderMode(GL_FEEDBACK)

    glEnableClientState(GL_VERTEX_ARRAY)

    glDrawRangeElements(GL_POINTS, 0, 2, 3, GL_UNSIGNED_BYTE, [0, 1, 2].pack("C*"))
    count = glRenderMode(GL_RENDER)
    assert_equal(count, 12)

    glDisableClientState(GL_VERTEX_ARRAY)
  end

  def test_colortable
    supported?(1.2)

    ct = ([0]*3+[1]*3+[0]*3+[1]*3).pack("f*")
    ct2 = ([1]*3+[0]*3+[1]*3+[0]*3).pack("f*")
    glColorTable(GL_COLOR_TABLE, GL_RGB8, 4, GL_RGB, GL_FLOAT, ct)
    assert_equal(glGetColorTable(GL_COLOR_TABLE, GL_RGB, GL_FLOAT), ct)

    glColorSubTable(GL_COLOR_TABLE, 0, 4, GL_RGB, GL_FLOAT, ct2)
    assert_equal(glGetColorTable(GL_COLOR_TABLE, GL_RGB, GL_FLOAT), ct2)

    glDrawPixels(4, 1, GL_RGB, GL_FLOAT, ct)
    glCopyColorTable(GL_COLOR_TABLE, GL_RGB8, 0, 0, 4)
    assert_equal(glGetColorTable(GL_COLOR_TABLE, GL_RGB, GL_FLOAT), ct)

    glDrawPixels(4, 1, GL_RGB, GL_FLOAT, ct2)
    glCopyColorSubTable(GL_COLOR_TABLE, 0, 0, 0, 4)
    assert_equal(glGetColorTable(GL_COLOR_TABLE, GL_RGB, GL_FLOAT), ct2)

    glColorTableParameterfv(GL_COLOR_TABLE, GL_COLOR_TABLE_BIAS, [0, 1, 0, 1])
    assert_equal(glGetColorTableParameterfv(GL_COLOR_TABLE, GL_COLOR_TABLE_BIAS), [0, 1, 0, 1])

    glColorTableParameteriv(GL_COLOR_TABLE, GL_COLOR_TABLE_BIAS, [1, 0, 1, 0])
    assert_equal(glGetColorTableParameteriv(GL_COLOR_TABLE, GL_COLOR_TABLE_BIAS), [1, 0, 1, 0])
  end

  def test_convolutionfilter
    supported?(1.2)

    cf = ([0]*3+[1]*3+[0]*3+[1]*3).pack("f*")
    cf2 = ([1]*3+[0]*3+[1]*3+[0]*3).pack("f*")
    glConvolutionFilter1D(GL_CONVOLUTION_1D, GL_RGB8, 4, GL_RGB, GL_FLOAT,cf)
    assert_equal(glGetConvolutionFilter(GL_CONVOLUTION_1D, GL_RGB, GL_FLOAT),cf)

    glConvolutionFilter2D(GL_CONVOLUTION_2D, GL_RGB8, 2,2, GL_RGB, GL_FLOAT,cf2)
    assert_equal(glGetConvolutionFilter(GL_CONVOLUTION_2D, GL_RGB, GL_FLOAT),cf2)

    glDrawPixels(4,1,GL_RGB,GL_FLOAT,cf2)
    glCopyConvolutionFilter1D(GL_CONVOLUTION_1D,GL_RGB8,0,0,4)
    assert_equal(glGetConvolutionFilter(GL_CONVOLUTION_1D, GL_RGB, GL_FLOAT),cf2)

    glDrawPixels(2,2,GL_RGB,GL_FLOAT,cf)
    glCopyConvolutionFilter2D(GL_CONVOLUTION_2D,GL_RGB8,0,0,2,2)
    assert_equal(glGetConvolutionFilter(GL_CONVOLUTION_2D, GL_RGB, GL_FLOAT),cf)

    glConvolutionParameterf(GL_CONVOLUTION_1D,GL_CONVOLUTION_BORDER_MODE,GL_CONSTANT_BORDER)
    assert_equal(glGetConvolutionParameterfv(GL_CONVOLUTION_1D,GL_CONVOLUTION_BORDER_MODE),GL_CONSTANT_BORDER)

    glConvolutionParameterf(GL_CONVOLUTION_1D,GL_CONVOLUTION_BORDER_MODE,GL_REPLICATE_BORDER)
    assert_equal(glGetConvolutionParameterfv(GL_CONVOLUTION_1D,GL_CONVOLUTION_BORDER_MODE),GL_REPLICATE_BORDER)

    glConvolutionParameterfv(GL_CONVOLUTION_1D,GL_CONVOLUTION_BORDER_MODE,[GL_CONSTANT_BORDER])
    assert_equal(glGetConvolutionParameterfv(GL_CONVOLUTION_1D,GL_CONVOLUTION_BORDER_MODE),GL_CONSTANT_BORDER)

    glConvolutionParameteri(GL_CONVOLUTION_1D,GL_CONVOLUTION_BORDER_MODE,GL_REPLICATE_BORDER)
    assert_equal(glGetConvolutionParameteriv(GL_CONVOLUTION_1D,GL_CONVOLUTION_BORDER_MODE),GL_REPLICATE_BORDER)

    glConvolutionParameteriv(GL_CONVOLUTION_1D,GL_CONVOLUTION_BORDER_MODE,[GL_CONSTANT_BORDER])
    assert_equal(glGetConvolutionParameteriv(GL_CONVOLUTION_1D,GL_CONVOLUTION_BORDER_MODE),GL_CONSTANT_BORDER)
  end

  def test_separablefilter
    supported?(1.2)
    sf_a = ([0]*3+[1]*3).pack("f*")
    sf_b = ([1]*3+[0]*3).pack("f*")

    glSeparableFilter2D(GL_SEPARABLE_2D, GL_RGB8, 2, 2, GL_RGB, GL_FLOAT, sf_a, sf_b)
    assert_equal(glGetSeparableFilter(GL_SEPARABLE_2D, GL_RGB, GL_FLOAT), [sf_a, sf_b])
  end

  def test_histogram
    supported?(1.2)

    glEnable(GL_HISTOGRAM)

    glHistogram(GL_HISTOGRAM, 1, GL_RGB, GL_FALSE)
    assert_equal(glGetHistogramParameterfv(GL_HISTOGRAM, GL_HISTOGRAM_WIDTH), 1)
    assert_equal(glGetHistogramParameteriv(GL_HISTOGRAM, GL_HISTOGRAM_FORMAT), GL_RGB)
    assert_equal(glGetHistogramParameteriv(GL_HISTOGRAM, GL_HISTOGRAM_SINK), GL_FALSE)

    glDrawPixels(2, 1, GL_RGB, GL_FLOAT, [1, 1, 1, 1, 1, 1].pack("f*"))
    h = glGetHistogram(GL_HISTOGRAM, GL_FALSE, GL_RGB, GL_FLOAT)
    assert_equal(h.unpack("f*"), [2, 2, 2])
    glResetHistogram(GL_HISTOGRAM)
    h = glGetHistogram(GL_HISTOGRAM, GL_FALSE, GL_RGB, GL_FLOAT)
    assert_equal(h.unpack("f*"), [0, 0, 0])

    glDisable(GL_HISTOGRAM)
  end

  def test_minmax
    supported?(1.2)

    glEnable(GL_MINMAX)

    glMinmax(GL_MINMAX, GL_RGB, GL_FALSE)
    assert_equal(glGetMinmaxParameteriv(GL_MINMAX, GL_MINMAX_FORMAT), GL_RGB)
    assert_equal(glGetMinmaxParameterfv(GL_MINMAX, GL_MINMAX_FORMAT), GL_RGB)
    assert_equal(glGetMinmaxParameteriv(GL_MINMAX, GL_MINMAX_SINK), GL_FALSE)

    glDrawPixels(2, 1, GL_RGB, GL_FLOAT, [0, 0, 0, 1, 1, 1].pack("f*"))
    mm = glGetMinmax(GL_MINMAX, GL_FALSE, GL_RGB, GL_FLOAT)
    assert_each_in_delta [0, 0, 0, 1, 1, 1], mm.unpack("f*")

    glResetMinmax(GL_MINMAX)
    mm = glGetMinmax(GL_MINMAX, GL_FALSE, GL_RGB, GL_UNSIGNED_BYTE)
    assert_equal [-1, -1, -1, 0, 0, 0], mm.unpack("c*")

    glDisable(GL_MINMAX)
  end

  def test_texture_3D
    supported?(1.2)
    image = ([0, 0, 0, 1, 1, 1] * 2 * 2).pack("f*")
    image2 = ([1, 1, 1, 0, 0, 0] * 2 * 2).pack("f*")

    textures = glGenTextures(1)
    glBindTexture(GL_TEXTURE_3D, textures[0])

    glTexImage3D(GL_TEXTURE_3D, 0, GL_RGB8, 2, 2, 2, 0, GL_RGB, GL_FLOAT, image)
    assert_equal(glGetTexImage(GL_TEXTURE_3D, 0, GL_RGB, GL_FLOAT), image)

    glTexSubImage3D(GL_TEXTURE_3D, 0, 0, 0, 0, 2, 2, 2, GL_RGB, GL_FLOAT, image2)
    assert_equal(glGetTexImage(GL_TEXTURE_3D, 0, GL_RGB, GL_FLOAT), image2)

    glDrawPixels(2, 2, GL_RGB, GL_FLOAT, image)
    glCopyTexSubImage3D(GL_TEXTURE_3D, 0, 0, 0, 0, 0, 0, 2, 2)
    ti = glGetTexImage(GL_TEXTURE_3D, 0, GL_RGB, GL_FLOAT).unpack("f*")
    assert_equal(ti, ([0]*3 + [1]*3) * 2 + ([1]*3 + [0]*3) * 2)

    glDeleteTextures(textures)
  end

end

